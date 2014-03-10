class Question < ActiveRecord::Base
  include Redis::Objects
  include Trackable

  attr_accessible :user, :user_id, :item, :content, :item_id, :post, :post_id

  # Relations
  belongs_to :user
  belongs_to :item
  belongs_to :post
  has_many :notifications, as: :content, dependent: :destroy

  # Callbacks
  after_commit :store_post_id_for_user, on: :create
  after_commit :store_question_id_for_post, on: :create
  after_commit :send_new_question_email_to_post_creator, on: :create
  after_commit :send_new_question_email_to_others, on: :create
  after_commit :send_new_question_notification_to_post_creator, on: :create
  after_commit :send_new_question_notification_to_others, on: :create
  before_create :assign_post
  after_commit :remove_post_id_from_redis, on: :destroy

  # Validations
  validates :content, presence: true

  # Redis attributes
  value :number_of_questions_asked
  
  # Methods

  # TODO Clean this up once client sends post id over
  def asked_by_post_creator?
    self.item.post.user_id == self.user_id
  end

  def notification_text(actor, for_type = nil)
    if number_of_questions_asked.value.blank?
      self.number_of_questions_asked = self.post.question_ids.count
    end

    text = self.number_of_questions_asked.value.to_i > 1 ? 'also left a comment' : 'left a comment'

    if for_type == :device
      "#{actor.first_name} #{actor.last_name} #{text} on #{post.title}"
    else
      "<b>#{actor.first_name} #{actor.last_name}</b> #{text} on <b>#{post.title}</b>"
    end
  end

  protected

  # TODO Clean this up once client sends post id over
  def store_post_id_for_user
    self.user.post_ids_with_questions << self.item.post_id
  end

  # TODO Remove this once client starts sending post id over
  def store_question_id_for_post
    self.item.post.question_ids << self.id
  end

  # TODO Remove this callback once client sends post id over
  def assign_post
    self.post_id = self.item.post_id
  end

  def send_new_question_email_to_post_creator
    Puhsh::Jobs::EmailJob.send_new_question_email_to_post_creator({question_id: self.id}) unless asked_by_post_creator?
  end

  def send_new_question_email_to_others
    Puhsh::Jobs::EmailJob.send_new_question_email_to_others({question_id: self.id})
  end

  def send_new_question_notification_to_post_creator
    Puhsh::Jobs::NotificationJob.send_new_question_notification_to_post_creator({question_id: self.id}) unless asked_by_post_creator?
  end

  def send_new_question_notification_to_others
    Puhsh::Jobs::NotificationJob.send_new_question_notification_to_others({question_id: self.id})
  end

  def remove_post_id_from_redis
    self.user.post_ids_with_questions.delete(self.post_id)
  end
end
