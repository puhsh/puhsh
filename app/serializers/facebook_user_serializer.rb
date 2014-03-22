class FacebookUserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :first_name, :last_name, :name, :avatar_urls, :star_count, :avatar_url, :zipcode, :longitude, :latitude, :location_description, :gender, 
             :facebook_email, :contact_email, :unread_notifications_count

  def id
    get_user_id
  end

  def uid
    get_user_uid
  end

  def first_name
    object['first_name']
  end

  def last_name
    object['last_name']
  end

  def name
    object['name']
  end

  def star_count
    object['star_count']
  end

  def avatar_url
    "http://graph.facebook.com/#{get_user_uid}/picture?type=square"
  end

  def avatar_urls
    {
      small: "http://graph.facebook.com/#{get_user_uid}/picture?type=small",
      normal: "http://graph.facebook.com/#{get_user_uid}/picture?type=normal",
      large: "http://graph.facebook.com/#{get_user_uid}/picture?type=large",
    }
  end

  def location_description
  end

  def zipcode
    object['zipcode']
  end

  def latitude
    object['latitude']
  end

  def longitude
    object['longitude']
  end

  def gender
    object['gender']
  end

  def facebook_email
    object['facebook_email']
  end

  def contact_email
    object['contact_email']
  end
  
  def unread_notifications_count
    object['unread_notifications_count']
  end

  protected

  def get_user_id
    object.kind_of?(User) ? object.id : nil
  end

  def get_user_uid
    object.kind_of?(User) ? object.uid : object['id']
  end
end
