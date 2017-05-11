default_action :create

property :name, kind_of: String, name_attribute: true, required: true
property :package_name, kind_of: String, required: false
property :config_path, kind_of: String, required: false
property :init_path, kind_of: String, required: false
property :default_init, kind_of: String, required: false
property :pid_path, kind_of: String, required: true
property :bin_path, kind_of: String, required: false
property :user, kind_of: String, required: false
property :group, kind_of: String, required: false
property :db_path, kind_of: String, required: false
property :log_path, kind_of: String, required: false
property :bind_address, kind_of: String, required: false
property :port, kind_of: String, required: false

action :create do
  if platform?('centos')
    yum_repository 'mongodb' do
      description 'MongoDB Repository'
      baseurl 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/'
      gpgkey 'https://www.mongodb.org/static/pgp/server-3.4.asc'
      action :create
    end
  elsif platform?('ubuntu')
    apt_repository 'mongodb' do
      uri 'http://repo.mongodb.org/apt/ubuntu'
      distribution 'xenial/mongodb-org/3.4'
      components ['multiverse']
      keyserver 'hkp://keyserver.ubuntu.com:80'
      key 'EA312927'
    end
  end

  package new_resource.package_name

  service 'mongodb' do
    action [:disable, :stop]
  end

  file new_resource.default_init do
    action :delete
  end

  directory new_resource.pid_path do
    owner new_resource.user
    group new_resource.group
    action :create
  end

  directory "#{new_resource.db_path}_#{new_resource.name}" do
    owner new_resource.user
    group new_resource.group
    action :create
  end

  directory new_resource.log_path do
    owner new_resource.user
    group new_resource.group
    action :create
  end

  template "#{new_resource.init_path}/mongod_#{new_resource.name}" do
    source 'mongod_init.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      mongod_name: new_resource.name,
      mongod_bin: new_resource.bin_path,
      mongod_pid_path: new_resource.pid_path,
      mongod_conf: "#{new_resource.config_path}_#{new_resource.name}.conf",
      mongod_user: new_resource.user,
      mongod_group: new_resource.group
    )
    notifies :restart, "service[mongod_#{new_resource.name}]", :delayed
  end

  template "#{new_resource.config_path}_#{new_resource.name}.conf" do
    source 'mongod.conf.erb'
    owner 'root'
    group 'root'
    variables(
      mongod_pid_file: "#{new_resource.pid_path}/#{new_resource.name}.pid",
      mongod_db_path: "#{new_resource.db_path}_#{new_resource.name}",
      mongod_log_path: "#{new_resource.log_path}/#{new_resource.name}.log",
      mongod_port: new_resource.port,
      mongod_bindip: new_resource.bind_address
    )
    notifies :restart, "service[mongod_#{new_resource.name}]", :delayed
  end

  service "mongod_#{new_resource.name}" do
    action [:enable, :start]
  end
end

action :delete do
  service "mongod_#{new_resource.name}" do
    action [:disable, :stop]
  end

  if platform?('centos')
    yum_repository 'mongodb' do
      action :delete
    end
  elsif platform?('ubuntu')
    apt_repository 'mongodb' do
      action :remove
    end
  end

  package new_resource.package_name do
    action :remove
  end

  directory new_resource.pid_path do
    action :delete
  end

  directory new_resource.db_path do
    action :delete
  end

  directory new_resource.log_path do
    action :delete
  end

  file "#{new_resource.config_path}_#{new_resource.name}.conf" do
    action :delete
  end

  file "#{new_resource.init_path}/mongod_#{new_resource.name}" do
    action :delete
  end
end
