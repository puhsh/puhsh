module ApplicationHelper
  def facebook_avatar_url(user, size = nil)
    valid_sizes = [:large, :square, :normal]

    if size && valid_sizes.include?(size)
      user.avatar_url.split('?').first + "?type=#{size.to_s}"
    else
      user.avatar_url
    end
  end

  def facebook_share_this_url
    "http://www.facebook.com/sharer/sharer.php?u=#{request.url}"
  end

  def twitter_tweet_this_url
    'https://www.twitter.com/share'
  end

  def pinterest_pin_it_url 
    "http://www.pinterest.com/pin/create/button/?url=#{url_for(only_path: false)}"
  end

  def ios_app_store_url
    'https://itunes.apple.com/us/app/puhsh/id761535377?mt=8'
  end

  def android_app_store_url
    'https://play.google.com/store/apps/details?id=com.puhsh.puhshandroid&hl=en'
  end
end
