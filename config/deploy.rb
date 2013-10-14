require 'rvm/capistrano' 
require 'bundler/capistrano'

set :application, 'puhsh'
set :keep_releases, 10
set :repository, 'git@github.com:bryanmikaelian/puhsh.git'
set :scm, :git
set :branch, 'master'
set :deploy_to, '/web/puhsh'
set :bundle_without, [:development,:test]
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :rvm_ruby_string, 'ruby-1.9.3-p448@puhsh'
set :rake, "#{rake} --trace"
set :user, 'ubuntu'
set :use_sudo, false

ssh_options[:keys] = ["#{ENV["HOME"]}/.ssh/keys/puhsh/puhsh-key-pair-nvirgina.pem", "#{ENV["HOME"]}/.ssh/id_rsa"]
ssh_options[:forward_agent] = true

# server 'ec2-54-205-78-73.compute-1.amazonaws.com', :web, :app, :db, :primary => true
server '54.221.223.155', :web, :app, :db, :primary => true

namespace :deploy do

  desc 'Since we do not store local creds, symlink the example file'
  task :symlink_database_config, roles: [:app, :web] do
    run "ln -s #{release_path}/config/database.example.yml #{release_path}/config/database.yml"
  end

  desc 'Zero downtime'
  task :restart do
    run "kill -s USR2 `cat /tmp/unicorn.puhsh.pid`"
  end

  desc 'Restart nginx'
  task :restart_nginx do
    run 'sudo service nginx restart'
  end

end

# Before / After Tasks
after 'deploy:finalize_update', 'deploy:symlink_database_config'
