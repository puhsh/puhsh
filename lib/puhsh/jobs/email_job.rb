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

      def self.send_new_question_email_to_post_creator(opts)
        Resque.enqueue(self, :send_new_question_email_to_post_creator, opts)
      end

      def self.send_new_question_email_to_others(opts)
        Resque.enqueue(self, :send_new_question_email_to_others, opts)
      end

      def self.send_item_purchased_email(opts)
        Resque.enqueue(self, :send_item_purchased_email, opts)
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
          UserMailer.new_post_email(post).deliver
        end
      end

      def send_new_message_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        message = Message.find_by_id(opts[:message_id])
        if message
          UserMailer.new_message_email(message).deliver
        end
      end

      def send_new_question_email_to_post_creator(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.find_by_id(opts[:question_id])
        if question
          UserMailer.new_question_email(question).deliver
        end
      end

      def send_new_question_email_to_others(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.find_by_id(opts[:question_id])
        actor = question.user
        if question && question.post && actor
          users_to_receive_email = Question.includes(:user).where(post_id: question.post_id).where('user_id != ?', question.user).where('user_id != ?', question.post.user).collect(&:user).uniq
          users_to_receive_email.each do |user|
            UserMailer.new_question_after_question_email(question, user).deliver
          end
        end
      end

      def send_item_purchased_email(opts)
        opts = HashWithIndifferentAccess.new(opts)
        post = Post.find_by_id(opts[:post_id])
        user = User.find_by_id(opts[:user_id])
        if post && user
          UserMailer.item_purchased(post, user).deliver
        end
      end
    end
  end
end
