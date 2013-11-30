module BadgeRewardable
  extend ActiveSupport::Concern

  included do
    after_create :award_badges
  end

  protected

  def award_badges
    case self
    when User
      Badge.award!('Early Adopter', self) if User::ALPHA_ENABLED
    when Post
      Badge.award!('Newbie Poster', self.user) if self.user.posts_count_was == 0
    end
  end

end
