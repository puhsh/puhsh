require 'spec_helper'

describe Puhsh::Jobs::TextHelpers do

  class Puhsh::Jobs::DummyClass
    include Puhsh::Jobs::TextHelpers
  end

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:post) { FactoryGirl.create(:post, user: user) }
  let!(:item) { FactoryGirl.create(:item, post: post) }
  let!(:question) { FactoryGirl.build(:question, item: item, user: user2, content: 'Is this a good item?') }
  let!(:recipient) { FactoryGirl.create(:user) }
  let!(:message) { FactoryGirl.create(:message, sender: user, recipient: recipient, content: 'Test message' ) }
  let!(:dummy_class) { Puhsh::Jobs::DummyClass.new }

  describe '.notification_text' do
    it 'returns the notification text when a message is generated' do
      expect(dummy_class.notification_text(message)).to eql("#{user.first_name} #{user.last_name}: #{message.content}.")
    end

    it 'returns the notification text when a question is generated' do
      expect(dummy_class.notification_text(question)).to eql("#{user2.first_name} #{user2.last_name} left a comment on #{post.title}")
    end
  end
end
