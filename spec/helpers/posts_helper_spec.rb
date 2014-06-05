require 'spec_helper'

describe PostsHelper do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
  let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:post2) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:post3) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }

  describe '.post_image_list_class' do
    it 'returns the proper class when there is one image' do
      FactoryGirl.create(:post_image, post: post)
      expect(post_image_list_class(post.post_images.count)).to eql('inline-no-margin small-block-grid-1')
    end

    it 'returns the proper class when there are two images' do
      FactoryGirl.create(:post_image, post: post)
      FactoryGirl.create(:post_image, post: post)
      expect(post_image_list_class(post.post_images.count)).to eql('inline-no-margin small-block-grid-2')
    end

    it 'returns the proper class when there are three images' do
      FactoryGirl.create(:post_image, post: post)
      FactoryGirl.create(:post_image, post: post)
      FactoryGirl.create(:post_image, post: post)
      expect(post_image_list_class(post.post_images.count)).to eql('inline-no-margin small-block-grid-3')
    end
  end

  describe '.post_item_price_class' do
    it 'returns the proper class if the item is not free' do
      expect(post_item_price_class(item)).to eql('not-free')
    end
  end

  describe '.post_price' do
    it 'returns FREE for the item that is free' do
      item.price_cents = 0
      item.save
      expect(post_price(item)).to eql('FREE')
    end

    it 'returns SOLD for a post that is sold' do
      post.status = :sold
      post.save
      expect(post_price(item)).to eql('SOLD')
    end
  end

  describe '.post_category_display_name' do
    it 'returns a formatted category and subcategory name' do
      expect(post_category_display_name(post)).to eql("#{post.category_name.value} : #{post.subcategory_name.value}")
    end
  end

  describe '.post_location_name' do
    it 'returns the post location name formatted' do
      expect(post_location_name(user)).to eql("#{user.home_city.name}, #{user.home_city.state.upcase} (#{user.location_description})")
    end
  end

  describe '.post_time_posted' do
    it 'returns a formatted time' do
      expect(post_time_posted(post)).to eql(post.created_at.localtime.strftime("%B #{ActiveSupport::Inflector.ordinalize(post.created_at.day)}, %Y %l:%m %p"))
    end
  end

  describe '.post_pickup_location_name' do
    it 'displays porch properly' do
      post.pick_up_location = :porch
      post.save
      expect(post_pickup_location_name(post)).to eql('Porch Pick Up')
    end

    it 'displays public location properly' do
      post.pick_up_location = :public_location
      post.save
      expect(post_pickup_location_name(post)).to eql('Public Location')
    end

    it 'displays house properly' do
      post.pick_up_location = :house
      post.save
      expect(post_pickup_location_name(post)).to eql('In My House')
    end

    it 'displays nil properly' do
      post.pick_up_location = nil
      post.save
      expect(post_pickup_location_name(post)).to eql('Other')
    end

    it 'displays anything else properly' do
      post.pick_up_location = :other
      post.save
      expect(post_pickup_location_name(post)).to eql('Other')
    end
  end

  describe '.title_list' do
    it 'returns a comma separated list of titles' do 
      expect(title_list([post, post2, post3])).to eql('Test, Test, Test')
    end
  end

  describe '.category_list' do
    it 'returns a comma separated list of categories and subcategories' do 
      expect(category_list([post, post2, post3])).to eql("#{post.category_name.value} : #{post.subcategory_name.value}, #{post2.category_name.value} : #{post2.subcategory_name.value}, #{post3.category_name.value} : #{post3.subcategory_name.value}")
    end
  end
end
