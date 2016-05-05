# coding = utf-8

# require
# --------------------------------------------------------------------------------------------
require 'sinatra'
require 'erb'
require 'data_mapper'
require 'cgi'
require 'logger'
# require all controllers
Dir["./controllers/*.rb"].each {|file| require file}


# 工程设置
# --------------------------------------------------------------------------------------------
if ENV['ULIAPI_DB_URL'] || ENV['DATABASE_URL'] # heroku and mysql
	set :environment, :production
end
set :port, 4567
set :bind, '0.0.0.0'

# data_mapper init
# --------------------------------------------------------------------------------------------
# open logger
# DataMapper::Logger.new($stdout, :debug)

# use sqlite first
if ENV['DATABASE_URL'] # for heroku
	DataMapper.setup(:default, ENV['DATABASE_URL'])
elsif ENV['ULIAPI_DB_URL'] # mysql for product
	DataMapper.setup(:default, ENV['ULIAPI_DB_URL'])
else # sqlite for develop
	DataMapper.setup(:default, "sqlite://#{Dir.pwd}/models/db.sqlite")
end

# set string max length to 255
DataMapper::Property::String.length(512)

# requre all db file
Dir["./models/*.rb"].each {|file| require file}

DataMapper.finalize


# hepler for user content
# --------------------------------------------------------------------------------------------
helpers do  
    include Rack::Utils  
    alias_method :escape, :escape_html  
end 



# url map
# --------------------------------------------------------------------------------------------
# 首页
# ------------------------------------------------
get '/' do
	@projects = Project.all(:order => [:created_at.desc]) 

	erb :index
end


# 新增工程
# ------------------------------------------------
get '/project/create' do
	erb :project_edit
end

post '/project/create' do
	# create project
	project = Project.create_all(params)

	redirect "/project/#{project.id}"
end


# 查看工程详情
# ------------------------------------------------
get '/project/:id' do
	@project = Project.get(params[:id])
	@params = @project.global_parameters
	@interfaces = @project.interfaces

	erb :project
end


# 删除项目
# ------------------------------------------------
get "/project/:id/delete" do
	project = Project.get(params[:id]) 
	project.destroy_all

	redirect '/'
end


# 编辑项目
# ------------------------------------------------
get '/project/:id/edit' do
	@project = Project.get(params[:id])
	@params = @project.global_parameters

	erb :project_edit
end

post '/project/:id/edit' do
	project = Project.get(params[:id])
	project.update_all(params)

	redirect "/project/#{project.id}"
end


# 接口列表
# ------------------------------------------------
get '/project/:id/interface/all' do
	@project = Project.get(params[:id])
	@categories = Interface.grouped_by_category(params[:id])

	erb :interface_list
end


# 新建接口
# ------------------------------------------------

get '/project/:id/interface/create' do
	@project = Project.get(params[:id])
	@categories = Interface.all(:project_id => @project.id, :fields => [:category], :unique => true)

	erb :interface_edit, :locals => {:input_params=>nil,:out_success_params=>nil,:out_fail_params=>nil}
end

post '/project/:id/interface/create' do
	project = Project.get(params[:id])
	interface = Interface.create_all(params)
	project.interfaces << interface
	project.save

	redirect "/project/#{params[:id]}/interface/#{interface.id}"
end


# 编辑接口
# ------------------------------------------------
get '/project/:project_id/interface/:interface_id/edit' do
	@project = Project.get(params[:project_id])
	@global_parameters = GlobalParameter.all(:project_id => @project.id)
	@categories = Interface.all(:project_id => @project.id, :fields => [:category], :unique => true)
	@interface_id = params[:interface_id]
	@interface = Interface.get(@interface_id)
	@interface_map = InterfaceParameterMap.all(:interface_id => @interface.id)

	erb :interface_edit, :locals => @interface.grouped_params
end

post '/project/:project_id/interface/:interface_id/edit' do
	Interface.get(params[:interface_id]).update_all(params)

	redirect "/project/#{params[:project_id]}/interface/#{params[:interface_id]}"
end


# 删除接口
# ------------------------------------------------
get '/project/:project_id/interface/:interface_id/delete' do
	interface = Interface.get(params[:interface_id])
	interface.destroy_all

	redirect "/project/#{params[:project_id]}/interface/all"
end


# 查看接口详情
# ------------------------------------------------
get '/project/:project_id/interface/:interface_id' do
	info = {
		:project => Project.get(params[:project_id]),
		:interface => Interface.get(params[:interface_id]),
		:global_parameters => GlobalParameter.all(:project_id => params[:project_id]), # 从项目中继承而来的全局参数
		:categories => Interface.grouped_by_category(params[:project_id]), #右边的侧边栏也难用，所有接口按category分类
	}
	info = info.merge(info[:interface].grouped_params) # 加入接口参数，按找接口类型分组
	info = info.merge(info[:interface].full_urls) #加入接口的实际参数

	erb :interface, :locals => info
end


# 获取接口在线数据
# 为了解决json跨域的问题
# ------------------------------------------------
get '/interface/refresh' do
	url = params[:url]
	if url != nil and not url.empty? and url =~ URI::regexp
		url = CGI.unescape(url)
		return Nestful.get url
	else
		'输入的url为空'
	end
end


# 伪数据处理
# ------------------------------------------------
get '/fake_data/:interface_id/*' do
	result = Interface.get(params[:interface_id]).output_success_sample
	if result.empty?
		return 'no data!!!'
	else
		result.gsub(/\s+/, '')
	end
end


# 下载单个接口文件
# ------------------------------------------------
get '/project/:project_id/interface/:interface_id/ios' do
	interface = Interface.get(params[:interface_id])

	redirect interface.ios_interface_file_urls
end

get '/project/:project_id/interface/ios/all' do
end


# 在线测试，伪数据设置
# ------------------------------------------------
get '/online_test' do
	erb :online_test
end
# get '/project/:project_id/interface/:interface_id/online/test' do
# 	info = {
# 		:project => Project.get(params[:project_id]),
# 		:interface => Interface.get(params[:interface_id]),
# 		:input_params => InterfaceParameter.all(:interface_id => params[:interface_id], :type => 'input'),
# 	}

# 	erb :online_test, :locals => info
# end

