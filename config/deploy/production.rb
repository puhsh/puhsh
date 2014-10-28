server 'ec2-54-88-115-1.compute-1.amazonaws.com', user: 'puhsh', roles: %w{web app db resque job}

set :application, 'puhsh'
set :deploy_to, "/var/www/www.puhsh.com"
set :stage, :production
set :rails_env, 'production'
