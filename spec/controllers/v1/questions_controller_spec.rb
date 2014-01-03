require 'spec_helper'

describe V1::QuestionsController do
  describe '#create' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { question: { item_id: item.id, content: 'Test' } }, format: :json
        expect(assigns[:question]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { question: { item_id: item.id, content: 'Test' } }, format: :json
        expect(assigns[:question]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'creates a question' do
        sign_in user
        post :create, { question: { item_id: item.id, content: 'Test' }, access_token: access_token.token }, format: :json
        expect(user.reload.questions).to include(assigns[:question])
      end
    end
  end
end
