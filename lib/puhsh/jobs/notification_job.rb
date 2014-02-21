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

      def send_new_message_notification(opts)
        opts = HashWithIndifferentAccess.new(opts)
        message = Message.find_by_id(opts[:message_id])
        if message
          Notification.new.tap do |notification|
            notification.user = message.recipient
            notification.actor = message.sender
            notification.content = message
            notification.read = false
          end.save
        end
      end

      def send_new_question_notification(opts)
        opts = HashWithIndifferentAccess.new(opts)
        question = Question.includes({item: [post: :user]}).find_by_id(opts[:question_id])
        if question
          Notification.new.tap do |notification|
            notification.user = question.item.post.user
            notification.actor = question.user
            notification.content = question
            notification.read = false
          end.save
        end
      end
    end
  end
end
