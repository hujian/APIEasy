# coding = utf-8

require 'erb'
require 'nestful'
# require 'zip/zip'
require 'find'

# 生成规则如下：
# 1. 传入的数据保证是一个dictionary object的json字符串
# 2. 传入这个接口的名称，以这个名称生成第一个model类。该类包含这json object最外层属性。
# 3. 遍历这个json object，发现有属性的值是hash类型，或者是hash类型数据的数组，则生成另外一个model类，该类包含这个hash类型的所有属性
# 4. 生成model类的名称，就是属性key的首字母大写。
# 5. 第4的列外情况是，model_file_name_map中指定的替换关系。

class IOSFactory
    attr_accessor :arc

    def initialize
        @type_map = {
            String => ["NSString*", "retain"],
            Fixnum => ["int", "assign"],
            Bignum => ["long", "assign"],
            Float => ["float", "assign"],
            TrueClass => ["BOOL", "assign"],
            FalseClass => ["BOOL", "assign"],
            Float => ["float", "assign"],
            Array => ["NSArray*", "retain"],
            Hash => ["", "retain"],
        }

        @interface_template_paths = %w{
            ./templates/model_interface_h.erb
            ./templates/model_interface_m.erb
        }

        @property_template_paths = %w{
            ./templates/model_property_h.erb
            ./templates/model_property_m.erb
        }

        @params_template_paths = %w{
            ./templates/model_params_h.erb
            ./templates/model_params_m.erb
        }

        @model_saving_path = './public/source/iOS'

        @model_download_url = '/source/iOS'
    end

    def capitalize(s)
        s[0, 1].capitalize + s[1..-1]
    end

    # 获取类属性的实际类型
    def property_ios_class(key, value)
        if value.class == Hash
            if @model_file_name_map != nil and nil != (@model_file_name_map[key])
                key = @model_file_name_map[key]
            end
            capitalize(key)
        elsif @type_map[value.class] != nil
            @type_map[value.class][0]
        else
            p "type #{value.class} of key #{key} does't exist"
            nil
        end
    end

    # mrc需要的memory类型
    def property_ios_memory_type(value)
        if nil != @type_map[value.class]
            return @type_map[value.class][1]
        else
            return ''
        end
    end

    # for erb template
    def get_binding
        binding
    end

    def parse_json_string_to_dictionary(json_string)
        json = json_string.gsub(/\s+/, '')
        parser = Yajl::Parser.new
        json = parser.parse(json)

        # 必须是hash类型的数据
        if json == nil or not json.instance_of? Hash
            return {}
        else
            return json
        end
    end

    def parse_property(key, value)
        property_ios_class = self.property_ios_class(key, value)
        property_ios_memory_type = self.property_ios_memory_type(value)
        property = {
            :name => key,
            :type => property_ios_class,
            :memory_type => property_ios_memory_type
        }

        @properties.push(property)

        if 'retain' == property_ios_memory_type
            @nilable_properties.push(property)
        end
        if Hash == value.class
            property[:type] += '*'
            @import_properties.push(property_ios_class)
        end
    end

    def dump_model_files(template_paths, saving_paths)
        # 通过erb模板生成interface类文件
        files = {}
        template_paths.each_with_index do |path, index|
            template = open(path)
            erb = ERB.new(template.read(), nil, '-')
            files[saving_paths[index]] = erb.result(get_binding)
        end
        files.each do |path, model_file|
            File.open(path, 'w') {|file| file.write(model_file)}
        end
    end

    def create_model_file(data, name, template_paths, sub_property_template_paths)
        @properties = [] # 类属性
        @nilable_properties = [] # 需要dealloc的属性
        @import_properties = [] # 需要在头文件中引用的属性，即属性的值是hash类型
        @model_name = name # name for model file

        # 解析接口属性，生成erb需要的实例数据
        data.each do |key, value|
            self.parse_property(key, value)
        end

        # 保存路径
        saving_paths = ["#{@saving_dir}/#{name}.h", "#{@saving_dir}/#{name}.m"]

        # 生成接口文件
        self.dump_model_files(template_paths, saving_paths)

        # 生成属性文件
        data.each do |key, value|
            if value.class == Hash
                create_model_file(value, self.property_ios_class(key, value), sub_property_template_paths, sub_property_template_paths)
            elsif value.class == Array and value[0].class == Hash
                create_model_file(value[0], self.property_ios_class(key, value[0]), sub_property_template_paths, sub_property_template_paths)
            end
        end
    end

    # data has to be dictionary json object
    def create_interface_model(data, name, model_file_name_map, interface)
        if nil == data || data.empty? || data.class != Hash
            return false
        end

        result = {}
        @interface = interface # interface itself
        @global_parameters = GlobalParameter.all(:project_id => interface.project_id) # project全局参数
        @saving_dir = "#{@model_saving_path}/interface_#{interface.id}" # model文件保存目录
        @model_file_name_map = model_file_name_map

        #  如果目录存在，删掉他
        if File.directory? @saving_dir
            FileUtils.rm_rf(@saving_dir)
        end
        Dir.mkdir @saving_dir

        # 生成接口文件
        self.create_model_file(data, name, @interface_template_paths, @property_template_paths)

        return true
    end

    # 生成输入参数文件
    def create_input_param_model(params, name)
        self.create_model_file(params, name, @params_template_paths, @params_template_paths)
    end

    def zip_interface_model
        if @saving_dir != nil and not @saving_dir.empty?
            interface_id = @interface.id
            zip_file_name = "interface_#{interface_id}.zip"
            zip_file_path = "#{@saving_dir}/#{zip_file_name}" 
            Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
                Find.find(@saving_dir) do |path|
                    if File.file?(path)
                        zipfile.add(File.basename(path), path)
                    end
                end
            end
            return "#{@model_download_url}/interface_#{@interface.id}/#{zip_file_name}" 
        else
            return ''
        end
    end
end
