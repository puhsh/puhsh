class RelatedProduct
  include ActiveModel::Serialization

  def self.search(query, user, session_id)
    if query && user

      user_location = [user.latitude, user.longitude].join(",")

      client = Sterling::API::Client.new
      client.products(user_location, query, session_id)
    else
      []
    end
  end
end
