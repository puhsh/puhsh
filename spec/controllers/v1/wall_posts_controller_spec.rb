require 'spec_helper'

describe V1::WallPostsController do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { wall_post: { post_type: :alpha_share } }, format: :json
        expect(assigns[:wall_post]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { wall_post: { post_type: :alpha_share } }, format: :json
        expect(assigns[:wall_post]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'creates a wall post' do
        sign_in user
        post :create, { wall_post: { post_type: :alpha_share }, access_token: access_token.token }, format: :json
        expect(user.reload.wall_posts).to include(assigns[:wall_post])
      end
    end
  end
end
