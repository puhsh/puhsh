module BadgeRewardable
  extend ActiveSupport::Concern

  included do
    after_create :award_badges
  end

  protected

  def award_badges
    case self
    when Post
      Badge.award!('Newbie Poster', self.user) if self.user.posts_count_was == 0
      Badge.award!('Pioneer Badge', self.user) if self.city && self.city.posts_count_was == 0
    end
  end

end
