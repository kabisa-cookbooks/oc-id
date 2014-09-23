include_recipe 'nginx::default'

template "#{node['nginx']['dir']}/sites-available/#{node['ocid']['name']}" do
  source   'nginx.erb'
  cookbook node['ocid']['nginx_cookbook']
  owner    node['ocid']['user']
  group    node['ocid']['group']
  mode     '0644'
end

execute "nxensite #{node['ocid']['name']}" do
  not_if "test -f #{node['nginx']['dir']}/sites-enabled/#{node['ocid']['name']}"
end
