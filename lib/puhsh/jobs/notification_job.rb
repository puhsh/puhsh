module Puhsh
  module Jobs
    class NotificationJob
      include TextHelpers

      @queue = :notifications

      def self.perform(method, *args)
        new.send(method, *args)
      end

      def self.send_new_message_notification(opts)
        Resque.enqueue(self, :send_new_message_notification, opts)
      end

      def self.send_new_question_notification_to_post_creator(opts)
        Resque.enqueue(self, :send_new_question_notification_to_post_creator, opts)
      end

      def self.send_new_question_notification_to_others(opts)
        Resque.enqueue(self, :send_new_question_notification_to_others, opts)
      end

      def send_new_message_notification(opts)
        opts = HashWithIndifferentAccess.new(opts)
        message = Message.find_by_id(opts[:message_id])
        recipient = message.try(&:recipient)
        sender = message.try(&:sender)

        if message && recipient && sender
          Notification.new.tap do |notification|
            notification.user = recipient
            notification.actor = sender
            notification.content = message
            notification.read = false
          end.save

          recipient.devices.ios.each do |device|
            device.fire_notification!(notification_text(message), :new_message)
          end
        end
      end

      def send_new_question_notification_to_post_creator(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.includes({item: [post: :user]}).find_by_id(opts[:question_id])
        user = question.item.post.user
        if question && user
          Notification.fire!(user, question)
          send_push_notification_for_question_to_user_devices(question, user)
        end
      end

      def send_new_question_notification_to_others(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.includes({item: [post: :user]}).find_by_id(opts[:question_id])
        if question && question.post
          users = Question.includes(:user).where(post_id: question.post_id).where('user_id != ?', question.user).where('user_id != ?', question.post.user).collect(&:user)
          users.each do |user|
            Notification.fire!(user, question)
            send_push_notification_for_question_to_user_devices(question, user)
          end
        end
      end

      protected 

      def send_push_notification_for_question_to_user_devices(question, user)
        user.devices.ios.each do |device|
          device.fire_notification!(notification_text(question), :new_question)
        end
      end
    end
  end
end
