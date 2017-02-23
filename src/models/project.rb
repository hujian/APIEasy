# coding = utf-8

class Project
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true
	property :host_product, String
	property :host_develop, String
	property :host_fake, String
	property :detail, Text
	property :created_at, DateTime
	property :update_at, DateTime
	property :status, String

	has n, :global_parameters
	has n, :interfaces

	# 生成project和相关联的其他数据
	def Project.create_all(params)

		# create project
		info = Project.basic_info_from_http_params(params)
		# 生成时间额外需要更新
		info[:created_at] = Time.now
		project = Project.create(info)

		# create global params
		project.create_global_params(params)

		return project
	end

	# 从前端传入的数据中抽取project basic info，并插入更新时间
	def Project.basic_info_from_http_params(params)
		return {
			:name => params[:project_name],
			:host_product => params[:host_product],
			:host_develop => params[:host_develop],
			:host_fake => params[:host_fake],
			:detail => params[:project_detail],
			:update_at => Time.now,
			:status => params[:project_status],
		}
	end

	# 从前端数据生成全局参数
	def create_global_params(params)
		if params[:param_name] != nil
			params[:param_name].each_with_index do |name, index|
				unless name.empty?
					param = GlobalParameter.create(
						:name => name,
						:sample => params[:param_sample][index],
						:detail => params[:param_detail][index]
					)
					self.global_parameters << param
				end
			end
			self.save
		end
	end

	def update_all(params)

		self.update(
			Project.basic_info_from_http_params(params)
		)

		# 保险起见，所有参数，全部新建
		self.global_parameters.destroy
		self.create_global_params(params)
	end

	def destroy_all
		# 删除项目全局参数
		self.global_parameters.destroy

		# 删除项目接口
		self.interfaces.each do |interface|
			interface.interface_parameters.destroy
			interface.interface_parameter_maps.destroy
		end
		self.interfaces.destroy

		self.destroy
	end
end

class GlobalParameter
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true
	property :sample, Text, :length => 500000 
	property :detail, Text, :length => 500000

	belongs_to :project
end
