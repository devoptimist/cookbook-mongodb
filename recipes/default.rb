#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node['mongodb']['instances'].each do |name, params|
  mongodb_instance name do
    package_name params['package_name'] || node['mongodb']['package_name']
    config_path params['config_path']   || node['mongodb']['config_path']
    default_init params['default_init'] || node['mongodb']['default_init']
    init_path params['init_path']       || node['mongodb']['init_path']
    pid_path params['pid_path']         || node['mongodb']['pid_path']
    bin_path params['bin_path']         || node['mongodb']['bin_path']
    user params['user']                 || node['mongodb']['user']
    group params['group']               || node['mongodb']['group']
    db_path params['db_path']           || node['mongodb']['db_path']
    log_path params['log_path']         || node['mongodb']['log_path']
    bind_address params['bind_address'] || node['mongodb']['bind_address']
    port params['port']                 || node['mongodb']['port']
    action params['state']
  end
end
