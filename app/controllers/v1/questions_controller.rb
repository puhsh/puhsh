class V1::QuestionsController < V1::ApiController
  before_filter :skip_trackable
  before_filter :verify_access_token
  load_and_authorize_resource

  def create
    @question = Question.new(params[:question])
    @question.user = current_user

    if @question.save
      render json: @question
    else
      not_acceptable!
    end
  end
end
