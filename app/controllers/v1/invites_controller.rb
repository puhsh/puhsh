class V1::InvitesController < V1::ApiController
  before_filter :skip_trackable
  before_filter :authenticate_user!
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @invites = Invite.create_multiple(params[:invites])
    render json: @invites
  end
end
