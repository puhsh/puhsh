class V1::UsersController < V1::ApiController
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  def create
  end

  def update
  end

  def destroy
  end
end
