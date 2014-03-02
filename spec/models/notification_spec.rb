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

  describe '.increment_unread_count_for_user' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.build(:notification, user: user, actor: actor, content: message) }

    it 'updates the unread count for a user if the notification is unread' do
      notification.save
      expect(user.reload.unread_notifications_count).to eql(1)
    end

    it 'does not update the unread count for a user if the notification is read' do
      notification.read = true
      notification.save
      expect(user.reload.unread_notifications_count).to eql(0)
    end
  end

  describe '.decrement_unread_count_for_user' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.build(:notification, user: user, actor: actor, content: message) }

    it 'updates the read count for a user if the notification is marked as read' do
      notification.save
      expect(user.reload.unread_notifications_count).to eql(1)
      notification.mark_as_read!
      expect(user.reload.unread_notifications_count).to eql(0)
    end

    it 'does not update the unread count for a user if the notification unread count was 0' do
      notification.save
      expect(user.reload.unread_notifications_count).to eql(1)
      user.unread_notifications_count = 0
      user.save
      notification.mark_as_read!
      expect(user.reload.unread_notifications_count).to_not eql(-1)
    end
  end
end
