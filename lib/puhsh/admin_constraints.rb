module Puhsh
  class AdminConstraints
    def self.matches?(request)
      user = request.env['warden'].authenticate(:scope => :user)
      user && user.has_role?(:admin)
    end
  end
end
