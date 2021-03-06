module Puhsh
  module AlphaQueue

    OFFSET = 2215

    def activate!
      self.update_attributes(status: :active)
      self.user.devices.ios.each { |x| x.fire_notification!("The wait is over... Puhsh is alive! Put down your coffee and go sell something.", :app_invite_accepted) } if self.user
    end

    def users_in_front_of_user
      (self.position - self.class.total_active) - 1
    end

    def current_position
      self.position - self.class.total_active
    end

    protected

    def set_status
      self.status = :inactive
    end

  end
end
