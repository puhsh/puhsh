# config valid only for Capistrano 3.1
lock '3.1.0'

set :repo_url, 'git@github.com:puhsh/puhsh.git'
set :branch, 'master'
set :user, 'puhsh'

set :scm, :git
set :format, :pretty
set :log_level, :debug
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system solr}
set :scm, :git
set :use_sudo, true

set :bundle_without, [:development,:test]
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :rvm_ruby_version, 'ruby-2.0.0-p247@puhsh'
set :max_asset_age, 2 

set :ssh_options, {
  keys: ["#{ENV["HOME"]}/.ssh/id_rsa"],
  forward_agent: true
}

namespace :deploy do

  desc 'Restart Unicorn'
  task :restart do
    on roles(:web), wait: 5 do
      execute 'kill -s USR2 `cat /tmp/unicorn.puhsh.pid`'
    end
  end

  desc 'Restart nginx'
  task :restart_nginx do
    on roles(:app), wait: 5 do
      execute 'sudo service nginx restart'
    end
  end

  desc 'Stop the Rapns daemon for Push Notifications'
  task :stop_rapns do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc 'Start the Rapns daemon for Push Notifications'
  task :start_rapns do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc 'Stop Solr'
  task :stop_solr do
    on roles(:web), wait: 5 do
      execute "cd #{release_path} && bundle exec sunspot-solr stop --port=8983 --pid-dir=tmp/pids"
    end
  end

  desc 'Start Solr'
  task :start_solr do
    on roles(:web), wait: 5 do
      execute "cd #{release_path} && bundle exec sunspot-solr start --port=8983 --pid-dir=tmp/pids"
    end
  end

  after :finished, :restart

end
