AMAZON_ADS_API_CONFIG = YAML.load_file("#{Rails.root}/config/amazon-ads.yml")[Rails.env].symbolize_keys
