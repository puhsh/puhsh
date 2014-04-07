class RelatedProduct
  include ActiveModel::Serialization

  def self.search(query, user, session_id)
    if query && user

      user_location = [user.latitude, user.longitude].join(",")

      client = Sterling::API::Client.new
      products = client.products(user_location, query, session_id)
      if products
        products.reject { |x| x.product['images'].empty? }
      end
    else
      []
    end
  end
end
