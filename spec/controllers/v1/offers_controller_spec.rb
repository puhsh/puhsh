require 'spec_helper'

describe V1::OffersController do

  describe '#create' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { offer: { item_id: item.id, amount_cents: 600, user: user, post: new_post } }, format: :json
        expect(assigns[:offer]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { offer: { item_id: item.id, amount_cents: 600, user: user, post: new_post } }, format: :json
        expect(assigns[:offer]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'creates an offer with a price' do
        sign_in user
        post :create, { offer: { item_id: item.id, amount_cents: 600, post_id: new_post.id, user_id: user.id }, access_token: access_token.token }, format: :json
        expect(user.reload.offers).to include(assigns[:offer])
      end

      it 'creates an offer without a price' do
        sign_in user
        post :create, { offer: { item_id: item.id, amount_cents: 0, post_id: new_post.id, user_id: user.id }, access_token: access_token.token }, format: :json
        expect(user.reload.offers).to include(assigns[:offer])
      end

      it 'sets the offer to pending' do
        sign_in user
        post :create, { offer: { item_id: item.id, amount_cents: 0, post_id: new_post.id, user_id: user.id }, access_token: access_token.token }, format: :json
        expect(assigns[:offer].status).to eql(:pending)
      end

      it 'sets the offer to awarded' do
        sign_in user
        post :create, { offer: { item_id: item.id, amount_cents: 0, post_id: new_post.id, user_id: user.id, status: :awarded}, access_token: access_token.token }, format: :json
        expect(assigns[:offer].status).to eql(:awarded)
      end
    end
  end
end
