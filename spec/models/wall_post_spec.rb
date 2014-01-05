require 'spec_helper'

describe WallPost do
  it { should belong_to(:user) }

  describe '.post_type' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:wall_post) { FactoryGirl.build(:wall_post, user: user) }

    it 'is required' do
      wall_post.save
      expect(wall_post).to_not be_valid
    end

    context ':alpha_share' do
      it 'can only have three of wall posts of this post_type' do
        wall_post.post_type = :alpha_share
        wall_post.save
        expect(wall_post).to be_valid

        valid = WallPost.create(user: user, post_type: :alpha_share)
        expect(valid).to be_valid

        valid2 = WallPost.create(user: user, post_type: :alpha_share)
        expect(valid2).to be_valid

        invalid = WallPost.new(user: user, post_type: :alpha_share)
        invalid.save
        expect(invalid).to_not be_valid
      end
    end
  end

  describe '.reward_stars' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:wall_post) { FactoryGirl.build(:wall_post, user: user) }

    context ':alpha_share' do
      it 'grants 50 stars when a wall post is created' do
        wall_post.post_type = :alpha_share
        wall_post.save
        expect(user.reload.star_count).to eql(60)
      end
    end
  end
end
