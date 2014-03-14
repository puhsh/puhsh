class FacebookUserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :first_name, :last_name, :name, :avatar_urls, :star_count, :avatar_url, :zipcode, :longitude, :latitude, :location_description, :gender, 
             :facebook_email, :contact_email, :unread_notifications_count

  def id
    object.kind_of?(User) ? object.id : nil
  end

  def uid
    object.kind_of?(User) ? object.uid : object['id']
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
    "http://graph.facebook.com/#{object['id']}/picture?type=square"
  end

  def avatar_urls
    {
      small: "http://graph.facebook.com/#{object['id']}/picture?type=small",
      normal: "http://graph.facebook.com/#{object['id']}/picture?type=normal",
      large: "http://graph.facebook.com/#{object['id']}/picture?type=large",
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
end
