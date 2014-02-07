module Puhsh
  module Jobs
    class EmailJob
      @queue = :email

      def self.perform(method, *args)
        send(method, *args)
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
          # send welcome email
        end
      end

      def send_new_post_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        post = Post.find_by_id(opts[:post_id])
        if post
          # send new post email
        end
      end

      def send_new_message_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        message = Message.find_by_id(opts[:message_id])
        if message
          # send new message email
        end
      end

      def send_new_question_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.find_by_id(opts[:question_id])
        post = question.item.post
        user = post.user
        if user && user.contact_email
          # send new question email
        end
      end
    end
  end
end
