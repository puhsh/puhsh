server '75.126.213.98', user: 'puhsh', roles: %w{web app db}
server '50.23.243.61', user: 'puhsh', roles: %w{web app}
server '75.126.213.100', user: 'puhsh', roles: %w{resque job}

set :application, 'puhsh'
set :deploy_to, "/web/puhsh"
set :stage, :production
set :rails_env, 'production'
