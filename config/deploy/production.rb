server '75.126.213.98', user: 'puhsh', roles: %w{web app solr db}

set :application, 'puhsh'
set :deploy_to, "/web/puhsh"
set :stage, :production
