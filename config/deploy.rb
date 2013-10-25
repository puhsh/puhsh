require 'rvm/capistrano' 
require 'bundler/capistrano'
require 'hipchat/capistrano'

set :application, 'puhsh'
set :keep_releases, 10
set :repository, 'git@github.com:puhsh/puhsh.git'
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
set :max_asset_age, 2 

# HipChat settngs
set :hipchat_token, 'cc96625c3ca88a6ac4d79958addc4c'
set :hipchat_room_name, 'Fun Town'
set :hipchat_announce, false
set :hipchat_color, 'yellow'
set :hipchat_success_color, 'green'
set :hipchat_failed_color, 'red'
set :hipchat_message_format, 'text'
set :hipchat_client, HipChat::Client.new(hipchat_token)


ssh_options[:keys] = ["#{ENV["HOME"]}/.ssh/keys/puhsh/ec2-keypair.pem", "#{ENV["HOME"]}/.ssh/id_rsa"]
ssh_options[:forward_agent] = true

server 'ec2-54-221-223-155.compute-1.amazonaws.com', :web, :app, :db, primary: true

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
    hipchat_client[hipchat_room_name].send('Capistrano', 'Nginx has been restarted in production')
  end

  # Compliments of https://gist.github.com/mrpunkin/2784462
  namespace :assets do
    desc "Figure out modified assets."
    task :determine_modified_assets, :roles => assets_role, :except => { :no_release => true } do
      set :updated_assets, capture("find #{latest_release}/app/assets -type d -name .git -prune -o -mmin -#{max_asset_age} -type f -print", :except => { :no_release => true }).split
    end

    desc "Remove callback for asset precompiling unless assets were updated in most recent git commit."
    task :conditionally_precompile, :roles => assets_role, :except => { :no_release => true } do
      if(updated_assets.empty?)
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
    task :refresh_sitemap, :roles => [:app] do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
      hipchat_client[hipchat_room_name].send('Capistrano', 'Refreshing the sitemap in production.')
    end
  end
end

# Before / After Tasks
after 'deploy:finalize_update', 'deploy:symlink_database_config'
after "deploy:finalize_update", "deploy:assets:determine_modified_assets", "deploy:assets:conditionally_precompile"
