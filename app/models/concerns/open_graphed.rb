module OpenGraphed
  extend ActiveSupport::Concern

  included do
    value :facebook_access_token
  end

  def store_facebook_access_token!(generated_token)
    self.facebook_access_token = generated_token
  end

  def access_token_expired?
  end
end
