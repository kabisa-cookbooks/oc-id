# The name of the installed application. Used internally in some path names.
#
default['ocid']['name'] = 'ocid'

# Version of application to install. Accepts any git sha1 or ref as specified
# here: https://github.com/opscode/oc-id
#
# Examples:
#   * master
#   * e48a8
#   * 0.4.0
#
default['ocid']['version'] = 'master'

# The home path to install the application.
#
default['ocid']['path'] = File.join('', 'srv', node['ocid']['name'])

# The rails environment in which to start the OC-ID application.
#
default['ocid']['environment'] = 'production'

# If set to `true`, creates user and its group.
#
default['ocid']['manage_user'] = true

# The user which manages the application's webserver and file ownership.
#
default['ocid']['user'] = 'ocid'

# The group to which the oc-id user belongs.
#
default['ocid']['group'] = 'ocid'

# Install PostgreSQL database server.
#
default['ocid']['install_postgresql'] = true

# Create database for application.
#
default['ocid']['create_database'] = true

# Create owner for specified database.
#
default['ocid']['create_database_owner'] = true

# Grant owner all rights to tables inside specified database.
#
default['ocid']['grant_database_owner'] = true

# The bookcook used to find the `database.yml.erb` template.
#
default['ocid']['database_cookbook'] = 'oc-id'

# Below config variables are all converted to key/value pairs in the default
# `database.yml.erb` template.
#
default['ocid']['database'] = {
  node['ocid']['environment'] => {
    'username' => 'ocid',
    'adapter' =>  'postgresql',
    'encoding' => 'unicode',
    'pool' =>     16,
    'template' => 'template0',
    'database' => [node['ocid']['name'], node['ocid']['environment']].join('_')
  }
}

# The cookbook used to find the `application.yml.erb` template.
#
default['ocid']['config_cookbook'] = 'oc-id'

# Below config variables are all converted to key/value pairs in the default
# `application.yml.erb` template.
#
default['ocid']['config']['chef']['endpoint']     = 'https://33.33.33.10'
default['ocid']['config']['chef']['superuser']    = 'pivotal'
default['ocid']['config']['chef']['key_path']     = '/etc/chef/private.pem'
default['ocid']['config']['secret_key_base']      = 'CHANGE ME'
default['ocid']['config']['zendesk']['subdomain'] = 'getchef'
default['ocid']['config']['doorkeeper']['administrators'] = ['rainbowdash']

# The bookcook used to find the `unicorn.rb.erb` template.
#
default['ocid']['unicorn_cookbook'] = 'oc-id'

# The bookcook used to find the `nginx_app.erb` template.
#
default['ocid']['nginx_cookbook'] = 'oc-id'

# Server address used to configure Nginx.
#
default['ocid']['nginx']['server_name'] = '33.33.32.250'

# Server port to access application.
#
default['ocid']['nginx']['port'] = 80

# Ruby version used to prepare and run the application.
#
default['rubies']['list'] = ['ruby 1.9.3-p547']
default['chruby_install']['default_ruby'] = '1.9.3-p547'

# Password for the default `postgresql` database user.
# NOTE: be sure to change this in production, ideally by using some kind of
# encrypted string.
#
default['postgresql']['password']['postgres']  = 'Pl3a5e chainge ME?'
