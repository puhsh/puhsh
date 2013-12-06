require 'spec_helper'

describe V1::CategoriesController do
  let!(:category) { FactoryGirl.create(:category) }
  let!(:category_inactive) { FactoryGirl.create(:category, status: :inactive) }

  describe '#index' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { id: category.id }, format: :json
        expect(assigns[:categories]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { id: category.id }, format: :json
        expect(assigns[:categories]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'returns the categories' do
        sign_in user
        get :index, { id: category.id, access_token: access_token.token }, format: :json
        expect(assigns[:categories]).to include(category)
      end

      it 'does not return inactive categories' do
        sign_in user
        get :index, { id: category.id, access_token: access_token.token }, format: :json
        expect(assigns[:categories]).to_not include(category_inactive)
      end
    end
  end

  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :show, { id: category.id }, format: :json
        expect(assigns[:category]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :show, { id: category.id }, format: :json
        expect(assigns[:category]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'returns the category' do
        sign_in user
        get :show, { id: category.id, access_token: access_token.token }, format: :json
        expect(assigns[:category]).to eql(category)
      end
    end
  end
end
