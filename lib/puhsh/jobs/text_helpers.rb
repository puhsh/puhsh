module Puhsh
  module Jobs
    module TextHelpers

      def notification_text(resource)
        case resource
        when Question
          new_question_text(resource)
        when Message
          new_message_text(resource)
        else
          nil
        end
      end

      protected

      def new_question_text(question)
        user = question.user
        post = question.item.post
        "#{user.first_name} #{user.last_name} left a comment on #{post.title}"
      end

      def new_message_text(message)
        user = message.sender
        "#{user.first_name} #{user.last_name}: #{message.content}."
      end
    end
  end
end
