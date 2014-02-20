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

  describe '.mark_as_read!' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }

    it 'marks a message a read' do
      message.mark_as_read!
      expect(message.reload).to be_read
      expect(message.reload.read_at).to_not be_nil
    end
  end

  describe '.mark_all_as_read!' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }
    let!(:message2) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }
    let!(:message3) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }
    let!(:message4) { FactoryGirl.create(:message, sender: recipient, recipient: sender, content: 'Test message' ) }

    it 'marks all received messages as read' do
      Message.mark_all_as_read!(recipient)
      expect(message.reload).to be_read
      expect(message2.reload).to be_read
      expect(message3.reload).to be_read
      expect(message4.reload).to_not be_read
    end
  end

  describe '.send_new_message_email' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.build(:message, sender: sender, recipient: recipient, content: 'Test message' ) }

    before { ResqueSpec.reset! }

    it 'sends the new message email' do
      message.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_new_message_email, {message_id: message.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_new_message_email).with({'message_id' => message.id})
      ResqueSpec.perform_all(:email)
    end
  end

  describe '.recent_conversations_for_user' do
    let!(:sender) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Test message' ) }
    
    it 'returns the latest message updated at for a sender and their set of recipients' do
      Timecop.travel(Date.today + 1.day) do
        message2 = FactoryGirl.create(:message, sender: sender, recipient: recipient, content: 'Please answer')
        expect(Message.recent_conversations_for_user(sender)).to include(message2)
        expect(Message.recent_conversations_for_user(sender)).to_not include(message)
        Timecop.travel(Date.today + 2.day) do
          message3 = FactoryGirl.create(:message, sender: recipient, recipient: sender, content: 'Please answer this??')
          expect(Message.recent_conversations_for_user(sender)).to include(message3)
          expect(Message.recent_conversations_for_user(sender)).to_not include(message2)
          expect(Message.recent_conversations_for_user(sender)).to_not include(message)
        end
      end
    end
  end
end
