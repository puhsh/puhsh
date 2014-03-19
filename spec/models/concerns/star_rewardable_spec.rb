require 'spec_helper'

describe StarRewardable do
  describe '.reward_stars' do
    context 'User' do
      let!(:user) { FactoryGirl.build(:user) }
      it 'stores the subject properly when a new account is created' do
        user.save
        expect(Star.last.subject).to eql(user)
      end
    end

    context 'Invite' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:facebook_invite) { FactoryGirl.build(:invite, user: user, uid_invited: '123456') }
      it 'stores the subject properly when an invite is created' do
        facebook_invite.save
        expect(Star.last.subject).to eql(facebook_invite)
      end
    end

    context 'Post' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:post) { FactoryGirl.build(:post) }

      it 'stores the subject properly when a post is created' do
        post.save
        expect(Star.last.subject).to eql(post)
      end
    end

    context 'WallPost' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:wall_post) { FactoryGirl.build(:wall_post, user: user) }

      it 'stores the subject properly when a alpha share wall post is created' do
        wall_post.post_type = :alpha_share
        wall_post.save
        expect(Star.last.subject).to eql(wall_post)
      end

      it 'stores the subject properly when a post share wall post is created' do
        wall_post.post_type = :post_share
        wall_post.save
        expect(Star.last.subject).to eql(wall_post)
      end

      it 'stores the subject properly when a sms share wall post is created' do
        wall_post.post_type = :sms_share
        wall_post.save
        expect(Star.last.subject).to eql(wall_post)
      end

      it 'stores the subject properly when a app share wall post is created' do
        wall_post.post_type = :app_share
        wall_post.save
        expect(Star.last.subject).to eql(wall_post)
      end

      it 'stores the subject properly when a sold post share wall post is created' do
        wall_post.post_type = :sold_post_share
        wall_post.save
        expect(Star.last.subject).to eql(wall_post)
      end
    end
  end

  describe '.remove_stars' do
    context 'Post' do
      let!(:post) { FactoryGirl.create(:post) }

      it 'stores the subject properly when the post is deleted' do
        post.destroy
        expect(Star.last.subject).to eql(nil)
      end
    end
  end
end
