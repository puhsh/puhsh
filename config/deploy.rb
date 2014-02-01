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
set :log_level, :debug
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system solr}
set :git_enable_submodules, 1
set :rvm_ruby_version, 'ruby-2.0.0-p247@puhsh'
set :max_asset_age, 2 

namespace :deploy do

  desc 'Restart Unicorn'
  task :restart do
    on roles(:web, :app), wait: 5 do
      execute "kill -s USR2 `cat #{release_path}/tmp/pids/unicorn.puhsh.pid`"
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
      execute "kill -s HUP `cat #{release_path}/tmp/pids/rapns.puhsh.pid`"
    end
  end

  desc 'Start the Rapns daemon for Push Notifications'
  task :start_rapns do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc 'Stop Solr'
  task :stop_solr do
    on roles(:solr), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "bundle exec sunspot-solr stop --port=8983 --pid-dir=tmp/pids"
        end
      end
    end
  end

  desc 'Start Solr'
  task :start_solr do
    on roles(:solr), wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "bundle exec sunspot-solr start --port=8983 --pid-dir=tmp/pids --data-directory=solr/data"
        end
      end
    end
  end

  after :finished, :restart
  after :restart, :restart_rapns

end
