module OpenGraphed
  extend ActiveSupport::Concern

  included do
    value :facebook_access_token
    value :facebook_access_token_expires_at
  end

  module ClassMethods
    def find_verified_user(fb_id, fb_access_token)
      fb = Koala::Facebook::API.new(fb_access_token)
      fb_record = fb.get_object('me')
      fb_record['id'] == fb_id && verified?(fb_record) ? fb_record : nil
    end

    private

    def verified?(fb_record)
      fb_record['verified'] || FacebookTestUser.find_by_fbid(fb_record['id']).present?
    end
  end

  def store_facebook_access_token!(generated_token)
    self.facebook_access_token = generated_token
  end

  def facebook_friends
    self.facebook_connection.get_connections('me', 'friends', user_fields)
  end

  def mutual_friends(other_user_uid)
    self.facebook_connection.get_connections(other_user_uid, 'mutualfriends')
  end

  def facebook_friends_on_puhsh(page = 1, per_page = 20)
    uids = facebook_friends.map { |x| x['id'] }
    User.where(uid: uids).page(page).per(per_page)
  end

  def mutual_friends_on_puhsh(uid, opts={})
    data = self.mutual_friends(uid)
    uids = data.map { |x| x['id'] }
    puhsh_users = User.where(uid: uids).limit(30)
    if opts[:keep_facebook_users]
      puhsh_users_uids = puhsh_users.collect(&:uid)
      non_puhsh_users = data.reject { |x| puhsh_users_uids.include?(x['id']) }
      puhsh_users | non_puhsh_users
    else
      puhsh_users
    end
  end

  def facebook_avatar_url_with_size(original_url, size)
    if size && self.valid_avatar_size?(size)
      base_url = self.facebook_base_avatar_url(original_url)
      base_url + "?type=#{size.to_s}&width=100&height=100"
    else
      nil
    end
  end

  def cover_image_url
    me = self.facebook_connection.get_object("me", user_fields)
    if me && me['cover']
      me['cover']['source']
    else
      nil
    end
  end

  protected

  def facebook_connection
    @facebook_connection ||= Koala::Facebook::API.new(valid_facebook_access_token)
  end

  def valid_facebook_access_token
    if access_token_expired?
      exchange_facebook_token!
    end

    self.facebook_access_token.value 
  end

  def access_token_expired?
    if self.facebook_access_token_expires_at
      self.facebook_access_token_expires_at.value.to_i < Time.now.to_i
    else
      true
    end
  end

  def exchange_facebook_token!
   facebook = YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys!
   new_token = Koala::Facebook::OAuth.new(facebook[:id], facebook[:secret]).exchange_access_token_info(self.facebook_access_token.value)

   self.facebook_access_token = new_token['access_token']
   self.facebook_access_token_expires_at = new_token['expires']
  end

  def facebook_base_avatar_url(url)
    url.split('?').first
  end

  def user_fields
    {fields: 'id,first_name,last_name,name,cover'}
  end

  def valid_avatar_size?(size)
    [:square, :small, :normal, :large].include?(size)
  end
end
