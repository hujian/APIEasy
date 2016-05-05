# coding = utf-8

require 'yajl'

class Interface
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :path_product, String
	property :path_develop, String
	property :path_fake, String
	property :http_type, String
	property :category, String, :required => true
	property :detail, Text
	property :model_name, String
	property :created_at, DateTime
	property :update_at, DateTime
	property :output_success_sample, Text, :length => 500000
	property :output_fail_sample, Text
	property :success_test_url, String
	property :fail_test_url, String

	belongs_to :project
	has n, :interface_parameters
	has n, :interface_parameter_maps

	def Interface.create_all(params)
		info = Interface.basic_info_from_http_params(params)
		info[:created_at] = Time.now
		interface = Interface.create(info)

		# 生成参数
		interface.create_params(params)

		return interface
	end

	# 按照接口的所属类别分成多个组
	def Interface.grouped_by_category(project_id)
		interfaces = Interface.all(:project_id => project_id, :unique => true, :order => [:created_at.asc])
		Interface.parse_pair_with_key(interfaces, "category")
	end

	# array中每个成员都看成hash table，然后以key为筛选参数，相同value的object做为一个组
	def Interface.parse_pair_with_key(array, key)
		result_array = []
		# 辅助用的{}
		index_pairs = {}
		array.each do |object|
			value = object[key]
			if nil == index_pairs[value] 
				index_pairs[value] = [object]

				# 查看接口详情
				result_array.push(index_pairs[value])
			else
				index_pairs[value].push(object)
			end
		end
		return result_array
	end

	def Interface.basic_info_from_http_params(params)
		return {
			:name => params[:name],
			:path_product => params[:path_product],
			:path_develop => params[:path_develop],
			:path_fake => params[:path_fake],
			:http_type => params[:http_type],
			:detail => params[:detail],
			:model_name => params[:model_name],
			:category => params[:category],
			:update_at => Time.now,
			:output_success_sample => params[:intertace_output_success_sample],
			:output_fail_sample => params[:interface_output_fail_sample],
			:success_test_url => params[:success_test_url],
			:fail_test_url => params[:fail_test_url],
		}
	end

	def create_params(params)
		# 生成接口参数
		self.create_interface_params(self.interface_parameters, params[:input_name], params[:input_sample], params[:input_detail], "input", "String")
		self.create_interface_params(self.interface_parameters, params[:output_success_name], params[:output_success_sample], params[:output_success_detail], "output_success", params[:output_success_type])
		self.create_interface_params(self.interface_parameters, params[:output_fail_name], params[:output_fail_sample], params[:output_fail_detail], "output_fail", params[:output_fail_type])
		# 生成接口key替换
		self.create_interface_map(self.interface_parameter_maps, params[:orgin_key], params[:new_key])

		self.save
	end

	# create interface params from data
	# 几个数组的依次对应
	def create_interface_params(array, names, samples, details, type, data_type)
		unless names == nil || names.empty?
			names.each_with_index do |name, index|
				unless name.empty? || index > samples.length - 1 || index > details.length - 1
					param = InterfaceParameter.create(
						:name => name,
						:sample => samples[index],
						:detail => details[index],
						:type => type,
						:data_type => data_type[index],
					)
					array << param
				end
			end	
		end
	end

	# create interface map
	def create_interface_map(array, oldKeys, newKeys)
		unless oldKeys == nil || oldKeys.empty?
			oldKeys.each_with_index do |old, index|
				unless old.empty? || index > newKeys.length - 1
					pair = InterfaceParameterMap.create(
						:orgin_key => old,
						:new_key => newKeys[index],
						:replace => false,
					)
					array << pair
				end
			end
		end
	end

	# 把接口参数以类型分成几个组别
	def grouped_params
		return {
			:input_params => InterfaceParameter.all(:interface_id => self.id, :type => 'input'),
			:out_success_params => InterfaceParameter.all(:interface_id => self.id, :type => 'output_success'),
			:out_fail_params => InterfaceParameter.all(:interface_id => self.id, :type => 'output_fail'),
		}
	end

	# 获取完整路径 
	def full_url(host, path, params) 
		result = ''
		if not path.start_with? 'http://' and host.start_with? 'http://'
				result =  URI.join(host, path)
		else
			result = URI(path)
		end
		if not params.empty?
			result.query = URI.encode_www_form(params)
		end

		return result.to_s
	end

	# 返回接口完整的url
	def full_urls()
		# 接口参数 + 全局参数
		global_params = Hash[ GlobalParameter.all(:project_id => self.project_id).map {|p| [p.name, p.sample]} ]
		params = Hash[ InterfaceParameter.all(:interface_id => self.id, :type => 'input').map {|p| [p.name, p.sample]} ]
		params = params.merge(global_params)

		project = Project.get(self.project_id)

		if not self.path_fake.start_with? '/'
			self.path_fake = '/' + self.path_fake
		end
		self.path_fake = "/fake_data/#{self.id}" + self.path_fake

		return {
			:path_product => self.full_url(project[:host_product], self.path_product, params),
			:path_develop => self.full_url(project[:host_develop], self.path_develop, params),
			:path_fake => self.full_url(project[:host_fake], self.path_fake, params),
		}
	end

	# 更新接口信息和接口关联的参数
	def update_all(params)
		self.update(
			Interface.basic_info_from_http_params(params)
		)
		self.interface_parameters.destroy
		self.interface_parameter_maps.destroy
		self.create_params(params)
	end

	def destroy_all
		self.interface_parameters.destroy
		self.interface_parameter_maps.destroy
		self.destroy
	end

	# 生成ios相关接口文件, 并返回文件路径
	def ios_interface_file_urls
		factory = IOSFactory.new

		# 生成接口文件和属性文件
		map = Hash[ InterfaceParameterMap.all(:interface_id => self.id).map {|d| [d.orgin_key, d.new_key]} ]
		interface_data = factory.parse_json_string_to_dictionary(self.output_success_sample)
		factory.create_interface_model(interface_data, self.model_name, map, self)
		# 生成参数文件
		params = Hash[ InterfaceParameter.all(:interface_id => self.id, :type => 'input').map {|p| [p.name, p.sample]} ]
		factory.create_input_param_model(params, "#{self.model_name}Parameter")

		return factory.zip_interface_model
	end
end

# 接口参数
class InterfaceParameter
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :sample, String
	property :detail, Text
	property :type, String      #接口分类类型
	property :data_type, String #数据类型

	belongs_to :interface
end

# 自动生成用的接口参数映射
class InterfaceParameterMap
	include DataMapper::Resource

	property :id, Serial
	property :orgin_key, String
	property :new_key, String
	property :replace, Boolean, :default => false

	belongs_to :interface
end

class InterfaceOnlineTest
	include DataMapper::Resource

	property :id, Serial
end