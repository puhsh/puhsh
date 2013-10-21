require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_many(:items) }


  context '.title' do
    let(:post) { FactoryGirl.build(:post, description: 'Foo bar') }

    it 'is required' do
      post.save
      expect(post).to_not be_valid
    end

  end

  context '.description' do
    let(:post) { FactoryGirl.build(:post, title: 'Foo bar') }

    it 'is required' do
      post.save
      expect(post).to_not be_valid
    end

  end

end
