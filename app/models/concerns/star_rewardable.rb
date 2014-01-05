module StarRewardable
  extend ActiveSupport::Concern

  included do
    after_create :reward_stars
    after_destroy :remove_stars
  end

  protected

  def reward_stars
    case self
    when User
      Star.create(user: self, amount: 10, event: :new_account)
    when Invite
      Star.create(user: self.user, amount: 3, event: :friend_invite)
    when Post
      Star.create(user: self.user, amount: 1, event: :new_post)
    when WallPost
      if self.alpha_share?
        Star.create(user: self.user, amount: 50, event: :shared_wall_post)
      end
    else
      nil
    end
  end

  def remove_stars
    case self
    when Post
      nil
    else
      nil
    end
  end
end
