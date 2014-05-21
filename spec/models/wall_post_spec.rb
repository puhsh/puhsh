require 'spec_helper'

describe WallPost do
  it { should belong_to(:user) }
  it { should have_one(:star) }

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

    context ':sms_share' do
      it 'can only have one wall post of this type' do
        wall_post.post_type = :sms_share
        wall_post.save
        expect(wall_post).to be_valid

        invalid = WallPost.create(user: user, post_type: :sms_share)
        expect(invalid).to_not be_valid
      end
    end

    context ':app_share' do
      it 'can only have one wall post of this type' do
        wall_post.post_type = :app_share
        wall_post.save
        expect(wall_post).to be_valid

        invalid = WallPost.create(user: user, post_type: :app_share)
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

    context ':sms_share' do
      it 'grants 100 stars when a wall post is created' do
        wall_post.post_type = :sms_share
        wall_post.save
        expect(user.reload.star_count).to eql(110)
      end
    end

    context ':post_share' do
      it 'grants 5 stars when a wall post is created' do
        wall_post.post_type = :post_share
        wall_post.save
        expect(user.reload.star_count).to eql(15)
      end
    end

    context ':sold_post_share' do
      it 'grants 5 stars when a wall post is created' do
        wall_post.post_type = :sold_post_share
        wall_post.save
        expect(user.reload.star_count).to eql(15)
      end
    end

    context ':email_share' do
      it 'grants 50 stars when a wall post is created' do
        wall_post.post_type = :email_share
        wall_post.save
        expect(user.reload.star_count).to eql(60)
      end
    end
  end
end
