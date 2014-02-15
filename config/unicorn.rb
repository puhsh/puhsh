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

# Make sure we are using the right unicorn in the right directory
Unicorn::HttpServer::START_CTX[0] = "#{rails_root}/bin/unicorn"

before_fork do |server, worker| 
  ENV['BUNDLE_GEMFILE'] = "#{rails_root}/Gemfile"
  server.logger.info("RAILS_ENV:: #{rails_env}")
  server.logger.info("Current directory: #{Dir.pwd}")
  server.logger.info("Current Gemfile: #{File.expand_path('Gemfile')}")
  server.logger.info("worker=#{worker.nr} spawning")

  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{rails_root}/tmp/pids/unicorn.puhsh.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      server.logger.info("worker #{worker.nr} sending QUIT to #{old_pid}")
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # pid already gone
      server.logger.info("#{old_pid} already removed")
    end
  end

  sleep 1
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
