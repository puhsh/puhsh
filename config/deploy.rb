require './config/boot'
require 'rvm/capistrano' 
require 'bundler/capistrano'
require 'hipchat/capistrano'
require 'airbrake/capistrano'
require 'new_relic/recipes'

set :application, 'puhsh'
set :keep_releases, 10
set :repository, 'git@github.com:puhsh/puhsh.git'
set :scm, :git
set :branch, 'master'
set :bundle_without, [:development,:test]
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :rvm_ruby_string, 'ruby-2.0.0-p247@puhsh'
set :rvm_type, :system
set :rake, "#{rake} --trace"
set :user, 'puhsh'
set :use_sudo, true
set :max_asset_age, 2 
set :cold_deploy, false

# HipChat settngs
set :hipchat_token, 'cc96625c3ca88a6ac4d79958addc4c'
set :hipchat_room_name, 'Fun Town'
set :hipchat_announce, false
set :hipchat_color, 'yellow'
set :hipchat_success_color, 'green'
set :hipchat_failed_color, 'red'
set :hipchat_message_format, 'text'
set :hipchat_client, HipChat::Client.new(hipchat_token)

ssh_options[:keys] = ["#{ENV["HOME"]}/.ssh/id_rsa"]
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

desc "Deploy to sandbox (usage: cap sandbox deploy)"
task :sandbox do
  set :default_shell, '/bin/bash -l'
  set :rails_env, 'sandbox'
  set :deploy_to, "/web/#{rails_env}.#{application}"
  server '50.23.243.59', :web, :app, :db, primary: true
end

desc "Deploy to production (usage: cap prod deploy)"
task :prod do
  require 'whenever/capistrano'
  set :rails_env, 'production'
  set :deploy_to, "/web/#{application}"
  server '75.126.213.98', :web, :app, :db, primary: true

  # CRON
  set :whenever_command, 'bundle exec whenever'
  set :whenever_roles, :app
end

namespace :deploy do

  desc 'Symlinks database.example.yml to database.yml'
  task :symlink_database_config, roles: [:app, :web] do
    run "ln -s #{release_path}/config/database.example.yml #{release_path}/config/database.yml"
  end

  desc 'Restart unicorn'
  task :restart do
    run "kill -s USR2 `cat /tmp/unicorn.puhsh.pid`"
  end

  desc 'Restart nginx'
  task :restart_nginx do
    run 'sudo service nginx restart'
    hipchat_client[hipchat_room_name].send('Capistrano', 'Nginx has been restarted on production')
  end

  desc 'Performs a cold deploy and forces assets to compile'
  task :cold_force do
    set :cold_deploy, true
    cold
  end

  desc 'Stop the Rapns daemon for Push Notifications'
  task :stop_rapns do
    run 'kill -9 `cat /tmp/rapns.puhsh.pid`'
  end

  task :start_rapns do
    run "cd #{current_path} && bundle exec rapns #{rails_env}"
  end

  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end

  # Compliments of https://gist.github.com/mrpunkin/2784462
  namespace :assets do
    desc "Figure out modified assets."
    task :determine_modified_assets, :roles => assets_role, :except => { :no_release => true } do
      set :updated_assets, capture("find #{latest_release}/app/assets -type d -name .git -prune -o -mmin -#{max_asset_age} -type f -print", :except => { :no_release => true }).split
    end

    desc "Remove callback for asset precompiling unless assets were updated in most recent git commit."
    task :conditionally_precompile, :roles => assets_role, :except => { :no_release => true } do
      if(updated_assets.empty? && !cold_deploy)
        callback = callbacks[:after].find{|c| c.source == "deploy:assets:precompile" }
        callbacks[:after].delete(callback)
        logger.info("Skipping asset precompiling, no updated assets.")
      else
        logger.info("#{updated_assets.length} updated assets. Will precompile.")
      end
    end
  end

  namespace :sitemap do
    desc 'Refreshes the sitemap'
    task :refresh, :roles => [:app] do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
      hipchat_client[hipchat_room_name].send('Capistrano', 'Refreshing the sitemap in production.')
    end
  end

  namespace :solr do
    desc 'start solr'
    task :start, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=tmp"
    end

    desc 'stop solr'
    task :stop, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=tmp"
    end
  end
end

#s Before / After Tasks
after 'deploy:setup', 'deploy:setup_solr_data_dir'
after 'deploy:finalize_update', 'deploy:symlink_database_config'
after "deploy:finalize_update", "deploy:assets:determine_modified_assets", "deploy:assets:conditionally_precompile"
