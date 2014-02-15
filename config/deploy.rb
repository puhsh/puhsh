# config valid only for Capistrano 3.1
lock '3.1.0'

set :ssh_options, {
  keys: ["#{ENV["HOME"]}/.ssh/id_rsa"],
  forward_agent: true
}

set :repo_url, 'git@github.com:puhsh/puhsh.git'
set :branch, 'master'
set :user, 'puhsh'
set :scm, :git
set :format, :pretty
set :log_level, :info
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/assets vendor/bundle public/system solr}
set :rvm_ruby_version, 'ruby-2.0.0-p247@puhsh'
set :max_asset_age, 2 
SSHKit.config.command_map[:whenever] = "bundle exec whenever"
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :keep_releases, 10

namespace :deploy do

  namespace :bower do
    desc 'Get Bower packages'
    task :install do
      on roles(:web, :app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :bundle, :exec, 'rake bower:install'
          end
        end
      end
    end
  end

  desc 'Start Unicorn'
  task :start_unicorn do
    on roles(:web, :app), wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "unicorn -c config/unicorn.rb -D -E #{fetch(:rails_env)}"
        end
      end
    end
  end

  desc 'Restart Unicorn'
  task :restart do
    on roles(:web, :app), wait: 5 do
      within current_path do
        execute "kill -s USR2 `cat #{current_path}/tmp/pids/unicorn.puhsh.pid`"
      end
    end
  end

  desc 'Reload Unicorn'
  task :reload_unicorn do
    on roles(:web, :app), wait: 5 do
      execute "kill -s HUP `cat #{current_path}/tmp/pids/unicorn.puhsh.pid`"
    end
  end

  desc 'Restart nginx'
  task :restart_nginx do
    on roles(:web, :app), wait: 5 do
      execute 'sudo service nginx restart'
    end
  end

  desc 'Restart the Rapns daemon for Push Notifications'
  task :restart_rapns do
    on roles(:web), in: :sequence, wait: 5 do
      execute "kill -s HUP `cat #{current_path}/tmp/pids/rapns.puhsh.pid`"
    end
  end

  desc 'Stop the resque pool'
  task :stop_resque_pool do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute "kill -s QUIT `cat #{current_path}/tmp/pids/resque-pool.pid`"
      end
    end
  end

  desc 'Start the resque pool'
  task :start_resque_pool do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :bundle, :exec, "resque-pool --daemon --environment #{fetch(:rails_env)}"
      end
    end
  end

  desc 'Restart the resque pool'
  task :restart_resque_pool do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute "kill -s HUP `cat #{current_path}/tmp/pids/resque-pool.pid`"
      end
    end
  end

  desc 'Stop Solr'
  task :stop_solr do
    on roles(:web, :solr), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "sunspot-solr stop --port=8983 --pid-dir=tmp/pids"
        end
      end
    end
  end

  desc 'Start Solr'
  task :start_solr do
    on roles(:web, :solr), wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "sunspot-solr start --port=8983 --pid-dir=tmp/pids --data-directory=#{current_path}/solr/data"
        end
      end
    end
  end

  after :finished, :restart
  after :restart, :stop_resque_pool
  after :stop_resque_pool, :start_resque_pool
  before 'deploy:updated', 'deploy:bower:install'
end
