# Workers
worker_processes 4

# Rails ENV
rails_env = Rails.env

# App Directory (via Capistrano)
working_directory rails_env == 'production' ? '/web/puhsh/current' : "/web/#{rails_env}.puhsh/current"

# Load app in master process
preload_app true

# Timeout in seconds to nuke workers
timeout 30

# Logging locations
if rails_env == 'production'
  stderr_path "/web/puhsh/shared/log/unicorn.stderr.log"
  stdout_path "/web/puhsh/shared/log/unicorn.stdout.log"
else
  stderr_path "/web/#{rails_env}.puhsh/shared/log/unicorn.stderr.log"
  stdout_path "/web/#{rails_env}.puhsh/shared/log/unicorn.stdout.log"
end

# App Directory (via Capistrano)
working_directory ENV['PWD']

# Load app in master process
preload_app true

# Timeout in seconds to nuke workers
timeout 30

# Logging locations 
stderr_path '/web/puhsh/shared/log/unicorn.stderr.log'
stdout_path '/web/puhsh/shared/log/unicorn.stdout.log'

# Listener on unix domain socket / TCP port
listen "/tmp/unicorn.puhsh.sock", :backlog => 64

# PID name
pid "/tmp/unicorn.puhsh.pid"

# Prevent calling the application for connections that dieded
check_client_connection false

before_fork do |server, worker| 
  # We don't need the master process hanging on to a DB connection
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect!

  # Rolling restarts
  old_pid = "/tmp/unicorn.puhsh.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # pid already gone
    end
  end
end

after_fork do |server, worker|
  # DB Connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # Redis Connection
  config =  YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
  $redis.client.disconnect
  $redis = Redis.new(config.symbolize_keys!)
end
