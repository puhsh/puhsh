require 'spec_helper'

describe V1::SubcategoriesController do
  let!(:subcategory) { FactoryGirl.create(:subcategory) }

  describe '#index' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { category_id: subcategory.category_id }, format: :json
        expect(assigns[:subcategories]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { category_id: subcategory.category_id }, format: :json
        expect(assigns[:subcategories]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'returns the subcategories' do
        sign_in user
        get :index, { category_id: subcategory.category_id, access_token: access_token.token }, format: :json
        expect(assigns[:subcategories]).to include(subcategory)
      end
    end
  end

  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :show, { category_id: subcategory.category_id, id: subcategory.id }, format: :json
        expect(assigns[:subcategory]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :show, { category_id: subcategory.category_id, id: subcategory.id }, format: :json
        expect(assigns[:subcategory]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'returns the subcategory' do
        sign_in user
        get :show, { category_id: subcategory.category_id, id: subcategory.id, access_token: access_token.token }, format: :json
        expect(assigns[:subcategory]).to eql(subcategory)
      end
    end
  end
end
