module Puhsh
  module Jobs
    class EmailJob
      @queue = :email

      def self.perform(method, *args)
        new.send(method, *args)
      end

      def self.send_welcome_email(opts)
        Resque.enqueue(self, :send_welcome_email, opts)
      end

      def self.send_new_post_email(opts)
        Resque.enqueue(self, :send_new_post_email, opts)
      end

      def self.send_new_message_email(opts)
        Resque.enqueue(self, :send_new_message_email, opts)
      end

      def self.send_new_question_email(opts)
        Resque.enqueue(self, :send_new_question_email, opts)
      end

      def send_welcome_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        user = User.find_by_id(opts[:user_id])
        if user
          UserMailer.welcome_email(user).deliver
        end
      end

      def send_new_post_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        post = Post.find_by_id(opts[:post_id])
        if post
          UserMailer.new_post_email(post)
        end
      end

      def send_new_message_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        message = Message.find_by_id(opts[:message_id])
        if message
          UserMailer.new_message_email(message)
        end
      end

      def send_new_question_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.find_by_id(opts[:question_id])
        if question
          UserMailer.new_question_email(question)
        end
      end
    end
  end
end
