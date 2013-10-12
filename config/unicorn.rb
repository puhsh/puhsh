# Workers
worker_processes 1

# App Directory (via Capistrano)
working_directory '/web/puhsh/current'

# Load app in master process
preload_app true

# Timeout in seconds to nuke workers
timeout 30

# Logging locations 
stderr_path '/web/puhsh/shared/log/unicorn.stderr.log'
stdout_path '/web/puhsh/shared/log/unicorn.stdout.log'

# Prevent calling the application for connections that dieded
check_client_connection false

before_fork do |server, worker| 
  # We don't need the master process hanging on to a DB connection
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
