module Facebook
  # Returns a Facebook user Hash if the given Facebook user ID and access token
  # identifiy a Verified Facebook user, nil otherwise.
  def self.verified_user(fb_id, fb_access_token)
    fb = Koala::Facebook::API.new(fb_access_token)
    fb_record = fb.get_object('me')
    fb_record['id'] == fb_id && verified?(fb_record) ? fb_record : nil
  end

  private

  def self.verified?(fb_record)
    fb_record['verified'] ||
      FacebookTestUser.find_by_fbid(fb_record['id']).present?
  end
end
