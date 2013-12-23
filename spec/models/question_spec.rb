require 'spec_helper'

describe Question do
  it { should belong_to(:user) }
  it { should belong_to(:item) }

  describe '.content' do
    let(:question) { FactoryGirl.build(:question, user: User.new) }

    it 'is required' do
      question.save
      expect(question).to_not be_valid
    end
  end

  describe '.store_question_id_for_post' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the question id in redis for the post' do
      question = Question.create(user: user, item: item, content: 'Is this a good item?')
      expect(post.reload.question_ids.members).to include(question.id.to_s)
    end
  end
end
