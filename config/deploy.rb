require 'capistrano-unicorn'
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
ssh_options[:keys] = ["#{ENV["HOME"]}/.ssh/keys/puhsh/puhsh-key-pair-nvirgina.pem", "#{ENV["HOME"]}/.ssh/id_rsa"]
ssh_options[:forward_agent] = true
set :use_sudo, false

server 'ec2-54-205-78-73.compute-1.amazonaws.com', :web, :app, :db, :primary => true
