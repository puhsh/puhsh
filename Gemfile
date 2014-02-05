source 'https://rubygems.org'

# Rails
gem 'rails', '3.2.16'

# MySQL
gem 'mysql2', '0.3.14'

# Redis
gem 'redis', '3.0.6'

# Resque
gem 'resque', '1.25.1', require: 'resque/server'
gem 'resque-pool', '0.3.0'

# View Engine
gem 'haml', '4.0.4'

# Omniauth
gem 'omniauth', '1.1.4'
gem 'omniauth-facebook', '1.5.1'

# Web Server
gem 'unicorn', '4.7.0'

# Storage
gem 'aws-sdk', '1.31.3'
gem 'paperclip', '3.5.2'

# Email
gem 'gibbon', '1.0.4'
gem 'mandrill-api', '~> 1.0.49'

# APN / GCM
gem 'rapns', '3.4.1'

# Peek
gem 'peek', '0.1.6'
gem 'peek-git', '1.0.2'
gem 'peek-performance_bar', '1.1.3'
gem 'peek-mysql2', '1.1.0'

# Assets
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '1.0.3'
  gem 'turbo-sprockets-rails3', '0.3.11'
end

group :development, :test do
  gem 'factory_girl', '4.3.0'
  gem 'factory_girl_rails', '4.3.0'
  gem 'fakeredis', '0.4.3'
  gem 'rspec-rails', '2.14.1'
  gem 'resque_spec', '0.14.4'
  gem 'shoulda', '3.5.0'
  gem 'spork', '1.0.0rc4'
  gem 'timecop', '0.7.1'
  gem 'vcr', '2.8.0'
  gem 'webmock', '1.16.1', require: false
end

group :development do
  gem 'capistrano', '3.1'
  gem 'capistrano-rvm', '0.1.1'
  gem 'capistrano-bundler', '1.1.1'
  gem 'capistrano-rails', '1.1'
  gem 'guard', '2.2.5'
  gem 'guard-rspec', '4.2.3'
  gem 'ruby_gntp'
end

group :test do
  gem 'ci_reporter', '1.9.1'
  gem 'test_after_commit', '0.2.2'
end

group :production do
  gem 'sitemap_generator', '4.2.0'
end

# Third Party
gem 'active_model_serializers', '0.8.1'
gem 'activeadmin'
gem 'acts_as_list', '0.3.0'
gem 'airbrake'
gem 'bootstrap-sass', '3.0.3.0'
gem 'cancan', '1.6.10'
gem 'devise', '2.2.8'
gem 'friendly_id', '~> 4.0.10.1'
gem 'geocoder', '1.1.9'
gem 'hipchat', '0.12.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari', '0.15.0'
gem 'koala', '1.6.0'
gem 'money-rails', '0.9.0'
gem 'newrelic_rpm', '3.5.8.72'
gem 'rails_warden', '0.5.7'
gem 'redis-objects', '0.8.0'
gem 'rolify', '3.2.0'
gem 'statsd-ruby', '1.2.1'
gem 'sunspot_rails', '2.1.0'
gem 'sunspot_solr', '2.1.0'
gem 'symbolize', '4.4.1'
gem 'whenever', '0.9.0', require: false
