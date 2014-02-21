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

      def self.send_new_question_notification(opts)
        Resque.enqueue(self, :send_new_question_notification, opts)
      end

      def self.send_new_post_notification(opts)
        Resque.enqueue(self, :send_new_post_notification, opts)
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
            device.fire_notification!(message.notification_text, :new_message)
          end
        end
      end

      def send_new_question_notification(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.includes({item: [post: :user]}).find_by_id(opts[:question_id])
        user = question.item.post.user
        if question
          Notification.new.tap do |notification|
            notification.user = user
            notification.actor = question.user
            notification.content = question
            notification.read = false
          end.save
          user.devices.ios.each do |device|
            device.fire_notification!("#{question.user.first_name} just asked a question.", :new_question)
          end
        end
      end

      def send_new_post_notification(opts)
        opts = HashWithIndifferentAccess.new(opts)
        post = Post.find_by_id(opts[:post_id])
        user = post.try(&:user)
        if post && user
          Notification.new.tap do |notification|
            notification.user = user
            notification.actor = user
            notification.content = post
            notification.read = false
          end.save
        end
      end
    end
  end
end
