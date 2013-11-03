class V1::UsersController < V1::ApiController
  before_filter :authenticate_user!
  before_filter :verify_access_token
  before_filter :forbidden!, only: [:create, :destroy]
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      render json: @user.reload
    else
      not_acceptable!
    end
  end

  def destroy
  end
end
