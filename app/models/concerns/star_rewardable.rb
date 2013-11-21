module StarRewardable
  extend ActiveSupport::Concern

  included do
    after_create :reward_stars
  end

  protected

  def reward_stars
    case self
    when User
      Star.create(user: self, amount: 10, event: :new_account)
    when Invite
      Star.create(user: self.user, amount: 3, event: :friend_invite)
    else
      nil
    end
  end
end
