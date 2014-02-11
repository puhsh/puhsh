module ApplicationHelper
  def facebook_avatar_url(user, size = nil)
    valid_sizes = [:large, :square, :normal]

    if size && valid_sizes.include?(size)
      user.avatar_url.split('?').first + "?type=#{size.to_s}"
    else
      user.avatar_url
    end
  end
end
