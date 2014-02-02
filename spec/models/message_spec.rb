require 'spec_helper'

describe Message do
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }

  describe '.content' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.build(:message, sender: sender, recipient: recipient) }

    it 'is required' do
      message.save
      expect(message).to_not be_valid
    end

    it 'cannot be longer than 160 character' do
      message.content = "msg " * 100
      message.save
      expect(message).to_not be_valid
    end
  end

  describe '.read' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.build(:message, sender: sender, recipient: recipient, content: 'Test message' ) }

    it 'is false by default' do
      message.save
      expect(message.reload).to_not be_read
    end
  end

  describe '.between_sender_and_recipient' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }
    let!(:message2) { FactoryGirl.create(:message, sender: recipient, recipient: sender, content: 'Test message' ) }

    it 'returns all messages between two individuals' do
      expect(Message.between_sender_and_recipient(sender, recipient)).to include(message)
      expect(Message.between_sender_and_recipient(sender, recipient)).to include(message2)
    end
  end
end
