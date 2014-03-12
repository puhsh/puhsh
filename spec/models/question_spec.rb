require 'spec_helper'

describe Question do
  it { should belong_to(:user) }
  it { should belong_to(:item) }
  it { should belong_to(:post) }
  it { should have_many(:notifications) }

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
      question = Question.create(user: user, item: item, content: 'Is this a good item?', post: post)
      expect(post.reload.question_ids.members).to include(question.id.to_s)
    end
  end

  describe '.store_post_id_for_user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the post id in redis for the question' do
      Question.create(user: user, item: item, content: 'Is this a good item?', post: post)
      expect(user.reload.post_ids_with_questions.members).to include(post.id.to_s)
    end
  end

  describe '.send_new_question_email_to_post_creator' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.build(:question, item: item, user: user2, content: 'Is this a good item?', post: post) }
    let!(:question_by_post_user) { FactoryGirl.build(:question, item: item, user: user, content: 'Yes this is a good item', post: post) }

    before { ResqueSpec.reset! }

    it 'sends the new question email' do
      question.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_new_question_email_to_post_creator, {question_id: question.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_new_question_email_to_post_creator).with({'question_id' => question.id})
      ResqueSpec.perform_all(:email)
    end

    it 'does not send a new question email if the post is owned by the user asking the question' do
      question_by_post_user.save
      expect(Puhsh::Jobs::EmailJob).to_not have_queued(:send_new_question_email_to_post_creator, {question_id: question_by_post_user.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to_not receive(:send_new_question_email_to_post_creator).with({'question_id' => question_by_post_user.id})
      ResqueSpec.perform_all(:email)

    end
  end

  describe '.send_new_question_email_to_others' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:user3) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.create(:question, item: item, user: user2, content: 'Is this a good item?', post: post) }
    let!(:question_by_post_user) { FactoryGirl.create(:question, item: item, user: user, content: 'Yes this is a good item', post: post) }
    let!(:question_by_someone_else) { FactoryGirl.build(:question, item: item, user: user3, content: 'I should buy this item?', post: post) }

    before { ResqueSpec.reset! }

    it 'sends the new question email to everyone' do
      question_by_someone_else.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_new_question_email_to_others, {question_id: question_by_someone_else.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_new_question_email_to_others).with({'question_id' => question_by_someone_else.id})
      ResqueSpec.perform_all(:email)
    end
  end

  describe '.send_new_question_notification_to_post_creator' do

    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.build(:question, item: item, user: user2, content: 'Is this a good item?', post: post) }
    let!(:question_by_post_user) { FactoryGirl.build(:question, item: item, user: user, content: 'Yes this is a good item', post: post) }
    let!(:device) { FactoryGirl.create(:device, device_type: :ios, device_token: "<faacd1a2 ca64c51c cddf2c3b cb9f52b3 40889c51 b6e641e1 fcb3a526 4d82e3e6>", user: user) }
    let!(:android_device) { FactoryGirl.create(:device, user: user, device_type: :android) }

    before { ResqueSpec.reset! }
    before do
      app = Rapns::Apns::App.new
      app.name = "puhsh_ios_test"
      app.certificate = File.read("#{Rails.root}/config/certs/puhsh_development.pem")
      app.environment = "development"
      app.connections = 1
      app.save!
    end

    it 'generates a new notification' do
      question.save
      expect(Puhsh::Jobs::NotificationJob).to have_queued(:send_new_question_notification_to_post_creator, {question_id: question.id})
      ResqueSpec.perform_all(:notifications)
      expect(user.notifications).to_not be_empty
      expect(user.notifications.count).to eql(1)
    end

    it 'does not generate a new notification if the question is asked by the post creator' do
      question_by_post_user.save
      expect(Puhsh::Jobs::NotificationJob).to_not have_queued(:send_new_question_notification_to_post_creator, {question_id: question.id})
      expect(user.notifications).to be_empty
    end

    it 'generates a APN' do
      question.save
      expect(Puhsh::Jobs::NotificationJob).to have_queued(:send_new_question_notification_to_post_creator, {question_id: question.id})
      expect_any_instance_of(Device).to receive(:fire_notification!)
      ResqueSpec.perform_all(:notifications)
    end

    it 'does not generate a GCM' do
      question.save
      expect(android_device).to_not receive(:fire_notification!)
      ResqueSpec.perform_all(:notifications)
    end
  end

  describe '.send_new_question_notification_to_others' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:user3) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.create(:question, item: item, user: user2, content: 'Is this a good item?', post: post) }
    let!(:question_by_post_creator) { FactoryGirl.create(:question, item: item, user: user, content: 'This item is good', post: post) }
    let!(:question_by_someone_else) { FactoryGirl.build(:question, item: item, user: user3, content: 'I should buy this item?', post: post) }
    let!(:device) { FactoryGirl.create(:device, device_type: :ios, device_token: "<faacd1a2 ca64c51c cddf2c3b cb9f52b3 40889c51 b6e641e1 fcb3a526 4d82e3e6>", user: user2) }
    let!(:android_device) { FactoryGirl.create(:device, user: user2, device_type: :android) }

    before { ResqueSpec.reset! }
    before do
      app = Rapns::Apns::App.new
      app.name = "puhsh_ios_test"
      app.certificate = File.read("#{Rails.root}/config/certs/puhsh_development.pem")
      app.environment = "development"
      app.connections = 1
      app.save!
    end

    it 'notifies everyone who asked a question for the post' do
      question_by_someone_else.save
      expect(Puhsh::Jobs::NotificationJob).to have_queued(:send_new_question_notification_to_others, {question_id: question_by_someone_else.id})
      ResqueSpec.perform_all(:notifications)
      expect(user.notifications.first.content).to eql(question_by_someone_else)
      expect(user.notifications.count).to eql(1)
      expect(user2.notifications.first.content).to eql(question_by_someone_else)
      expect(user2.notifications.count).to eql(1)
    end

    it 'does not notifiy the person who asked the question' do
      question_by_someone_else.save
      ResqueSpec.perform_all(:notifications)
      expect(user3.notifications).to be_empty
    end

    it 'generates a APN' do
      question_by_someone_else.save
      expect_any_instance_of(Device).to receive(:fire_notification!)
      ResqueSpec.perform_all(:notifications)
    end

    it 'does not generate a GCM' do
      question_by_someone_else.save
      expect(android_device).to_not receive(:fire_notification!)
      ResqueSpec.perform_all(:notifications)
    end
  end

  describe '.remove_post_id_from_redis' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: user) }
    let!(:item) { FactoryGirl.create(:item, post: post) }
    let!(:question) { FactoryGirl.create(:question, item: item, user: user2, content: 'Is this a good item?', post: post) }

    it 'removes the post id for the user when destroyed' do
      expect(user2.reload.post_ids_with_questions.members).to include(post.id.to_s)
      question.destroy
      expect(user2.reload.post_ids_with_questions.members).to_not include(post.id.to_s)
    end
  end
end
