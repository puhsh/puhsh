module Readable
  extend ActiveSupport::Concern

  included do
    scope :unread, where(read: false)
    scope :read, where(read: true)
  end

  module ClassMethods
    def mark_all_as_read!(user)
      unread.by_recipient(user).update_all(read: true, read_at: DateTime.now)
    end
  end

  def mark_as_read!
    if !self.read?
      self.read = true
      self.read_at = DateTime.now
      self.save
    end
  end
end
