require 'resque/pool/tasks'

task "resque:setup" => :environment do
  ActiveRecord::Base.connection.disconnect!
  Resque::Pool.after_prefork do
    ActiveRecord::Base.establish_connection
    $redis.client.reconnect
    Resque.redis.client.reconne
  end
end

task "resque:pool:setup" do
  ActiveRecord::Base.connection.disconnect!
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
    $redis.client.reconnect
    Resque.redis.client.reconnect
  end
end
