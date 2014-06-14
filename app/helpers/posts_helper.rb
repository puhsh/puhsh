module PostsHelper
  def post_image_list_class(count)
    "inline-no-margin small-block-grid-#{count}"
  end

  def post_item_price_class(item)
    'not-free' if item && item.price_cents > 0
  end

  def post_price(item)
    if item && item.post.for_sale?
      if item.price_cents > 0
        "$#{humanized_money item.price}"
      else
        'FREE'
      end
    else
      'SOLD'
    end
  end

  def post_category_display_name(post)
    "#{post.category_name.value} : #{post.subcategory_name.value}"
  end

  def post_location_name(user)
    city = user.home_city
    "#{city.name}, #{city.state.upcase} (#{user.location_description})"
  end

  def post_time_posted(post)
    day = post.created_at.day
    post.created_at.localtime.strftime("%B #{ActiveSupport::Inflector.ordinalize(day)}, %Y %l:%m %p")
  end

  def post_pickup_location_name(post)
    case post.pick_up_location
    when :porch
      'Porch Pick Up'
    when :public_location
      'Public Location'
    when :house
      'In My House'
    else
      'Other'
    end
  end

  def pickup_instructions
    url = 'http://www.puhsh.com/pickup-instructions.html'
    r = Net::HTTP.get_response(URI.parse(url))
    r.body
  end

  def title_list(posts, amount = 3)
    posts.to_a.take(amount).collect(&:title).join(", ")
  end

  def category_list(posts, amount = 3)
    posts.to_a.take(amount).collect { |post| "#{post.category_name.value} : #{post.subcategory_name.value}" }.join(", ")
  end
end
