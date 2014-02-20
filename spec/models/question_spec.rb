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

  describe '.store_post_id_for_user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the post id in redis for the question' do
      Question.create(user: user, item: item, content: 'Is this a good item?')
      expect(user.reload.post_ids_with_questions.members).to include(post.id.to_s)
    end
  end

  describe '.send_new_question_email' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.build(:question, item: item, user: user, content: 'Is this a good item?') }

    before { ResqueSpec.reset! }

    it 'sends the new question email' do
      question.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_new_question_email, {question_id: question.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_new_question_email).with({'question_id' => question.id})
      ResqueSpec.perform_all(:email)
    end
  end
end
