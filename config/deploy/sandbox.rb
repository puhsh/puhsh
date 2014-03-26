server '50.23.243.59', user: 'puhsh', roles: %w{web app db}

set :application, 'sandbox.puhsh'
set :deploy_to, "/web/sandbox.puhsh"
set :stage, :sandbox
set :rails_env, 'sandbox'
set :branch, ENV['BRANCH'] || 'master'
