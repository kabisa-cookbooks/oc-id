directory 'ocid_logs' do
  action :create
  path   File.join('', 'var', 'log', node['ocid']['name'])
  owner  node['ocid']['user']
  group  node['ocid']['group']
end

runit_service 'ocid' do
  action       :enable
  service_name node['ocid']['name']
  owner        node['ocid']['user']
  group        node['ocid']['group']
end

artifact_deploy node['ocid']['name'] do
  version             node['ocid']['version']
  artifact_location   'https://github.com/opscode/oc-id/archive/' \
                      "#{node['ocid']['version']}.tar.gz"
  deploy_to           node['ocid']['path']
  owner               node['ocid']['user']
  group               node['ocid']['group']
  shared_directories  %w(log pids system vendor_bundle assets)
  symlinks(
    'log'             => 'log',
    'system'          => 'public/system',
    'vendor_bundle'   => 'vendor/bundle',
    'assets'          => 'public/assets',
    'unicorn.rb'      => 'config/unicorn.rb',
    'database.yml'    => 'config/database.yml',
    'application.yml' => "config/settings/#{node['ocid']['environment']}.yml"
  )

  environment(
    'RAILS_ENV'       => node['ocid']['environment']
  )

  before_symlink proc {
    template "#{shared_path}/unicorn.rb" do
      source   'unicorn.rb.erb'
      cookbook node['ocid']['unicorn_cookbook']
      owner    node['ocid']['user']
      group    node['ocid']['group']
      mode     '0644'
    end

    template "#{shared_path}/application.yml" do
      source   'application.yml.erb'
      cookbook node['ocid']['config_cookbook']
      owner    node['ocid']['user']
      group    node['ocid']['group']
      mode     '0644'
    end

    template "#{shared_path}/database.yml" do
      source   'database.yml.erb'
      cookbook node['ocid']['database_cookbook']
      owner    node['ocid']['user']
      group    node['ocid']['group']
      mode     '0644'
    end
  }

  after_extract proc {
    execute 'flatten_folder_structure' do
      command 'find . -maxdepth 1 -exec mv {} .. \;'
      user    node['ocid']['user']
      group   node['ocid']['group']
      cwd     File.join(release_path, "oc-id-#{node['ocid']['version']}")
    end

    directory "#{release_path}/log" do
      action :delete
      recursive true
    end

    file "#{release_path}/config/database.yml" do
      action :delete
    end

    file "#{release_path}/config/settings/#{node['ocid']['environment']}.yml" do
      action :delete
    end
  }

  before_migrate proc {
    execute 'bundle[install]' do
      command     'chruby-exec 1.9 -- bundle install --path=vendor/bundle ' \
                  '--without test development'
      cwd         release_path
      environment('RAILS_ENV' => node['ocid']['environment'])
      user        node['ocid']['user']
      group       node['ocid']['group']
    end
  }

  migrate proc {
    execute 'rake[db:migrate]' do
      command     'chruby-exec 1.9 -- bundle exec rake db:migrate'
      cwd         release_path
      environment('RAILS_ENV' => node['ocid']['environment'])
      user        node['ocid']['user']
      group       node['ocid']['group']
    end
  }

  # We're using a condition-based `after_deploy` because the `restart` block
  # executes *before* `release_path` is symlinked to `current_path`. Given that
  # external resources (like an init script) always references the
  # `current_path`, we use this one only if a new symlink was created.
  #
  # See: https://github.com/RiotGames/artifact-cookbook/issues/68
  #
  after_deploy proc {
    if deploy? || manifest_differences?
      execute 'rake[assets:precompile]' do
        command     'chruby-exec 1.9 -- bundle exec rake assets:precompile'
        cwd         release_path
        environment('RAILS_ENV' => node['ocid']['environment'])
        user        node['ocid']['user']
        group       node['ocid']['group']
      end

      service 'nginx' do
        action :reload
      end

      runit_service 'ocid' do
        action       :usr2
        sv_timeout   30
        service_name node['ocid']['name']
      end
    else
      Chef::Log.debug 'Not restarting processes, no deployment was done.'
    end
  }

  keep 3
  should_migrate true
  force true
  action :deploy
end
