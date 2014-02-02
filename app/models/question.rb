class Question < ActiveRecord::Base
  attr_accessible :user, :item, :content, :item_id

  # Relations
  belongs_to :user
  belongs_to :item

  # Callbacks
  after_commit :store_post_id_for_user, on: :create
  after_commit :store_question_id_for_post, on: :create

  # Validations
  validates :content, presence: true
  
  # Methods

  protected

  def store_post_id_for_user
    self.user.post_ids_with_questions << self.item.post_id
  end

  def store_question_id_for_post
    self.item.post.question_ids << self.id
  end
end
