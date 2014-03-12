class AdminAuthentication < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    user && user.kind_of?(AdminUser)
  end
end
