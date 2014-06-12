module QuestionsHelper
  def question_time_asked(question)
    day = question.created_at.day
    question.created_at.localtime.strftime("%B #{ActiveSupport::Inflector.ordinalize(day)}, %Y %l:%m %p")
  end
end
