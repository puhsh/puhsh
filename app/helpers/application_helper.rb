module ApplicationHelper
  def dark_feature 
    yield unless Rails.env.production?
  end

  def facebook_avatar_url(user, size = nil)
    valid_sizes = [:large, :square, :normal]

    if size && valid_sizes.include?(size)
      user.avatar_url.split('?').first + "?type=#{size.to_s}"
    else
      user.avatar_url
    end
  end

  def facebook_share_this_url(resource = nil)
    if resource.kind_of?(Post)
      url_for(only_path: false)
    else
      'http://www.puhsh.com'
    end
  end

  def twitter_tweet_this_url(resource = nil)
    if resource.kind_of?(Post)
      url = url_for(only_path: false)
      "https://www.twitter.com/share?url=#{url}&text=Check out #{resource.title} on Puhsh!"
    else
      ''
    end
  end

  def pinterest_pin_it_url(resource = nil)
    if resource.kind_of?(Post)
      "http://www.pinterest.com/pin/create/button/?url=#{url_for(only_path: false)}&media=#{@post.post_images.first.image.url}&description=#{@post.title} (via Puhsh)"
    else
      ''
    end
  end

  def ios_app_store_url
    'https://itunes.apple.com/us/app/puhsh/id761535377?mt=8'
  end

  def android_app_store_url
    'https://play.google.com/store/apps/details?id=com.puhsh.puhshandroid&hl=en'
  end

  def bitly_url(long_url)
    begin
      Bitly.client.shorten(long_url).short_url
    rescue
      long_url
    end
  end

  def column_class(data)
    if data.size >= 75
      'medium-3'
    elsif data.size >= 50
      'medium-4'
    elsif data.size >= 25
      'medium-6'
    else
      'medium-12'
    end
  end

  def seo_keywords(content)
    content.split.join(", ")
  end

  def url_without_protocol(url)
    url.split(/^(http|https):/).last
  end
end
