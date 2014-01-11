require 'spec_helper'

describe V1::FlaggedPostsController do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
    let!(:new_post) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { flagged_post: {post_id: new_post.id }}, format: :json
        expect(assigns[:flagged_post]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { flagged_post: {post_id: new_post.id }}, format: :json
        expect(assigns[:flagged_post]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'creates a follow record' do
        sign_in user
        post :create, { flagged_post: { post_id: new_post.id }, access_token: access_token.token }, format: :json
        expect(user.reload.flagged_posts).to include(assigns[:flagged_post])
        expect(user.posts_flagged_count).to eql(1)
        expect(new_post.reload.flags_count).to eql(1)
      end
      
      it 'does not create duplicates' do
        FlaggedPost.create(user: user, post: new_post)
        sign_in user
        post :create, { flagged_post: { post_id: new_post.id }, access_token: access_token.token }, format: :json
        expect(user.reload.flagged_posts.count).to eql(1)
        expect(user.posts_flagged_count).to eql(1)
        expect(new_post.reload.flags_count).to eql(1)
      end
    end
  end

end
