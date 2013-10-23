class V1::ApiController < ActionController::Metal

  def index
    @user = User.first.to_json
    self.response_body = @user
  end
end
