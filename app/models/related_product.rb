class RelatedProduct
  include ActiveModel::Serialization

  def self.search(query, user)
    if query && user

      user_location = [user.latitude, user.longitude].join(",")
      requestor_id = Rails.env.production? ? 'test' : 'test'

       results = Retailigence::Product.search({
         userlocation: user_location,
         requestorid: requestor_id,
         name: query
       }).results

       results = results.reject { |x| x.url.nil? }
       results
    else
      {}
    end
  end
end
