module Puhsh
  class AdminConstraints
    def self.matches?(request)
      user = request.env['warden'].authenticate(:scope => :admin_user)
      user && user.kind_of?(AdminUser)
    end
  end
end
