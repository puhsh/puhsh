module OpenGraphed
  extend ActiveSupport::Concern

  included do
    value :facebook_access_token
    value :facebook_access_token_expires_at
  end

  def store_facebook_access_token!(generated_token)
    self.facebook_access_token = generated_token
  end

  protected

  def facebook_connection
    @facebook_connection ||= Koala::Facebook::API.new(valid_facebook_access_token)
  end

  def valid_facebook_access_token
    if access_token_expired?
      exchange_facebook_token!
    end

    self.facebook_access_token.value
  end

  def access_token_expired?
    if self.facebook_access_token_expires_at.value.blank?
      self.facebook_access_token_expires_at = Koala::Facebook::API.new(self.facebook_access_token.value).debug_token(self.facebook_access_token.value)['data']['expires_at']
    end

    self.facebook_access_token_expires_at.value.to_i < Time.now.to_i
  end

  def exchange_facebook_token!
   facebook = YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env]
   new_token = Koala::Facebook::OAuth.new(facebook['id'], facebook['secret']).exchange_access_token_info(self.facebook_access_token.value)

   self.facebook_access_token = new_token['access_token']
   self.facebook_access_token_expires_at = new_token['expires']
  end
end
