# Workers
worker_processes 4

# App Directory (via Capistrano)
rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = rails_env == 'production' ? '/web/puhsh/current' : "/web/#{rails_env}.puhsh/current"
working_directory rails_root

# Load app in master process
preload_app true

# Timeout in seconds to nuke workers
timeout 30

# Logging locations 
stderr_path "#{rails_root}/log/unicorn.stderr.log"
stdout_path "#{rails_root}/log/unicorn.stdout.log"

# Listener on unix domain socket / TCP port
listen "#{rails_root}/tmp/sockets/unicorn.puhsh.sock", :backlog => 64

# PID name
pid "#{rails_root}/tmp/pids/unicorn.puhsh.pid"

# Prevent calling the application for connections that dieded
check_client_connection false

before_fork do |server, worker| 
  server.logger.info("worker=#{worker.nr} spawning in #{Dir.pwd}")
  # We don't need the master process hanging on to a DB connection
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect!

  # Rolling restarts
  old_pid = "#{rails_root}/tmp/pids/unicorn.puhsh.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      server.logger.info("Current Directory: #{Rails.root.to_s}")
      server.logger.info("sending QUIT to #{old_pid}")
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # pid already gone
      server.logger.info("#{old_pid} already removed")
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
