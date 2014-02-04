require 'spec_helper'

describe Notification do
  it { should belong_to(:user) }
  it { should belong_to(:actor) }
  it { should belong_to(:content) }

  describe '.mark_as_read!' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }

    it 'marks a notification a read' do
      notification.mark_as_read!
      expect(notification.reload).to be_read
      expect(notification.reload.read_at).to_not be_nil
    end
  end

  describe '.mark_all_as_read!' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:message2) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:message3) { FactoryGirl.create(:message, sender: user, recipient: actor, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }
    let!(:notification2) { FactoryGirl.create(:notification, user: user, actor: actor, content: message2) }
    let!(:notification3) { FactoryGirl.create(:notification, user: actor, actor: user, content: message3) }

    it 'marks all received notifications as read' do
      Notification.mark_all_as_read!(user)
      expect(notification.reload).to be_read
      expect(notification2.reload).to be_read
      expect(notification3.reload).to_not be_read
    end
  end
end
