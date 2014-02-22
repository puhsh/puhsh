module Puhsh
  module Facebook
    def self.find_verified_user(fb_id, fb_access_token)
      fb = Koala::Facebook::API.new(fb_access_token)
      fb_record = fb.get_object('me')
      fb_record['id'] == fb_id && verified?(fb_record) ? fb_record : nil
    end

    def facebook_avatar_url_with_size(original_url, size)
      if size && valid_avatar_size?(size)
        base_url = facebook_base_avatar_url(original_url)
        base_url + "?type=#{size.to_s}"
      else
        nil
      end
    end

    private

    def self.verified?(fb_record)
      fb_record['verified'] || FacebookTestUser.find_by_fbid(fb_record['id']).present?
    end

    def facebook_base_avatar_url(url)
      url.split('?').first
    end

    def valid_avatar_size?(size)
      [:square, :small, :normal, :large].include?(size)
    end

  end
end
