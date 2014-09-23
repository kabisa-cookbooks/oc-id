include_recipe 'postgresql::ruby'
include_recipe 'postgresql::server' if node['ocid']['install_postgresql']

database = node['ocid']['database'][node['ocid']['environment']]

postgresql_connection_info = {
  host: '127.0.0.1',
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

database 'create_ocid' do
  action        :create
  only_if       { node['ocid']['create_database'] }
  database_name database['database']
  connection    postgresql_connection_info
  provider      Chef::Provider::Database::Postgresql
end

database_user 'create_ocid' do
  action        :create
  only_if       { node['ocid']['create_database_owner'] }
  username      database['username']
  password      database['password'] if database['password']
  database_name database['database']
  connection    postgresql_connection_info
  provider      Chef::Provider::Database::PostgresqlUser
end

database_user 'grant_ocid' do
  action        :grant
  only_if       { node['ocid']['grant_database_owner'] }
  username      database['username']
  privileges    [:all]
  database_name database['database']
  connection    postgresql_connection_info
  provider      Chef::Provider::Database::PostgresqlUser
end
