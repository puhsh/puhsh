mandrill = YAML.load_file("#{Rails.root}/config/mandrill.yml")[Rails.env].symbolize_keys!

MandrillMailer.configure do |config|
  config.api_key = mandrill[:key]
end
