group 'ocid' do
  action     :create
  only_if    { node['ocid']['manage_user'] }
  group_name node['ocid']['group']
  system     true
end

user 'ocid' do
  action   :create
  only_if  { node['ocid']['manage_user'] }
  username node['ocid']['user']
  gid      node['ocid']['group']
  home     node['ocid']['path']
  system   true
  shell    '/bin/false'
  comment  'Chef OC-ID'
  supports manage_home: true
end
