module StarRewardable
  extend ActiveSupport::Concern

  included do
    after_create :reward_stars
    after_destroy :remove_stars
  end

  protected

  def reward_additional_stars!(resource, event, amount)
    Star.create(user: resource.user, amount: amount, event: event, subject: resource)
  end

  def reward_stars
    case self
    when User
      Star.create(user: self, amount: 10, event: :new_account, subject: self)
    when Invite
      Star.create(user: self.user, amount: 3, event: :friend_invite, subject: self)
    when Post
      Star.create(user: self.user, amount: 10, event: :new_post, subject: self)
      Star.create(user: self.user, amount: 10, event: :pioneered_city, subject: self) if self.city && self.city.posts_count_was == 0
    when WallPost
      if self.alpha_share?
        Star.create(user: self.user, amount: 50, event: :shared_wall_post, subject: self)
      elsif self.post_share?
        Star.create(user: self.user, amount: 5, event: :shared_wall_post, subject: self)
      elsif self.sms_share?
        Star.create(user: self.user, amount: 100, event: :shared_sms, subject: self)
      elsif self.app_share?
        Star.create(user: self.user, amount: 50, event: :shared_wall_post, subject: self)
      elsif self.sold_post_share?
        Star.create(user: self.user, amount: 5, event: :shared_wall_post, subject: self)
      elsif self.email_share?
        Star.create(user: self.user, amount: 50, event: :shared_email, subject: self)
      end
    when Offer
      if self.awarded? && !self.sold_offline?
        Star.create(user: self.user, amount: 10, event: :bought_item, subject: self)
      end
    else
      nil
    end
  end

  def remove_stars
    case self
    when Post
      Star.create(user: self.user, amount: -10, event: :deleted_post, subject: self)
    else
      nil
    end
  end
end
