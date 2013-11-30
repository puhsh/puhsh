ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda'
require 'cancan/matchers'
require "paperclip/matchers"
require 'fakeredis'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers
  config.include Paperclip::Shoulda::Matchers
  config.order = "random"
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # We don't need redis running in the test environment
    $redis = Redis.new
  end

  OmniAuth.config.test_mode = true
  omniauth_hash = {
    :id => '1234',
    :name => 'John Doe',
    :first_name => 'John',
    :last_name => 'Doe',
    :username => 'johndoe',
    :location => { :name => 'Dallas, TX' },
    :gender => 'male',
    :email => 'john@test.local',
    :verified => true
  }

  omniauth_hash_invalid = {
    :id => '1234',
    :name => 'John Doe',
    :first_name => 'John',
    :last_name => 'Doe',
    :username => 'johndoe',
    :location => { :name => 'Dallas, TX' },
    :gender => 'male',
    :email => 'john@test.local',
    :verified => false
  }

  OmniAuth.config.add_mock(:facebook, omniauth_hash)
  OmniAuth.config.add_mock(:facebook_invalid, omniauth_hash_invalid)
  Geocoder.configure(:lookup => :test)
  Warden.test_mode!

  Geocoder::Lookup::Test.add_stub(
    '75022', []
  )

  Geocoder::Lookup::Test.add_stub(
    '75034', [
      {
        'latitude' => 33.1499,
        'longitude' => -96.8241,
        'address' => 'Frisco, TX, USA',
        'state' => 'Texas',
        'state_code' => 'NY',
        'country' => 'United States',
        'country_code' => 'US'
      }
    ]
  )

  Geocoder::Lookup::Test.add_stub(
    "New York, NY", [
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
        'address'      => 'New York, NY, USA',
        'state'        => 'New York',
        'state_code'   => 'NY',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )


  @facebook = YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env]

  FACEBOOK_APP_ID = @facebook['id']
  FACEBOOK_APP_SECRET = @facebook['secret']
end
