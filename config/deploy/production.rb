server '54.173.65.224', user: 'puhsh', roles: %w{web app db resque job}

set :application, 'puhsh'
set :deploy_to, "/var/www/www.puhsh.com"
set :stage, :production
set :rails_env, 'production'
