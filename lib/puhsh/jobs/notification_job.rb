module Puhsh
  module Jobs
    class NotificationJob

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
        actor = question.user
        if question && user && actor
          Notification.fire!(user, question)
          user.devices.ios.each do |device|
            device.fire_notification!(question.notification_text(actor), :new_question)
          end
        end
      end

      def send_new_question_notification_to_others(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.includes({item: [post: :user]}).find_by_id(opts[:question_id])
        actor = question.user
        if question && question.post && actor
          users_to_receive_notification = Question.includes(:user).where(post_id: question.post_id).where('user_id != ?', question.user).where('user_id != ?', question.post.user).collect(&:user)
          users_to_receive_notification.each do |user|
            Notification.fire!(user, question)
            user.devices.ios.each do |device|
              device.fire_notification!(question.notification_text(actor), :new_question)
            end
          end
        end
      end
    end
  end
end
