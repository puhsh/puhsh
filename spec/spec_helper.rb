ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda'
require 'cancan/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Devise::TestHelpers, :type => :controller
  config.order = "random"
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  OmniAuth.config.test_mode = true
  omniauth_hash =
    {:provider => "facebook",
      :uid      => "1234",
      :info   => {
        :name       => "John Doe",
        :first_name => "John",
        :last_name  => "Doe",
        :nickname   => "johndoe",
        :email      => "johndoe@email.com",
        :location   => "Dallas, TX",
        :image      => "http://graph.facebook.com/1234567/picture?type=square",
        :verified   => true
      },
      :credentials => {
        :token  => "testtoken234tsdf",
        :secret => "foobar"
      },
      :extra => {
        :raw_info => {
          :gender => 'male'
        }
      }
    }

  OmniAuth.config.add_mock(:facebook, omniauth_hash)
  Geocoder.configure(:lookup => :test)
  Geocoder::Lookup::Test.add_stub(
    '75033', []
  )

end
