config =  YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
$redis = Redis.new(config.symbolize_keys!)
Resque.redis = $redis
