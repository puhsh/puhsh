Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :token_authentication
  manager.failure_app = V1::ApiController
end

class Warden::SessionSerializer
  def serialize(record)
    [record.class.name, record.id]
  end

  def deserialize(keys)
    klass, id = keys
    klass.find(:first, :conditions => { :id => id })
  end
end

Warden::Strategies.add(:token_authentication) do
  def valid?
    params['auth_token']
  end

  def authenticate!
    auth_token = AccessToken.where(user_id: env['warden'].user.id, token: params['auth_token'])
    auth_token.nil? ? fail!('Forbidden') : success!(auth_token)
  end
end
