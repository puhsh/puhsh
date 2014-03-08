require 'spec_helper'

describe V1::NotificationsController do
  describe '#index' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, {}
        expect(assigns[:notifications]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index
        expect(assigns[:notifications]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'returns all the user\'s notifications' do
        sign_in user
        get :index, { access_token: access_token.token }
        expect(assigns[:notifications]).to include(notification)
      end
    end
  end

  describe '#update' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        put :update, { id: notification.id }
        expect(assigns[:notifications]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        put :update, { id: notification.id }
        expect(assigns[:notifications]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'updates the notification as read' do
        sign_in user
        put :update, { id: notification.id, access_token: access_token.token }
        expect(notification.reload).to be_read
      end

      it 'does not update a notification that cannot be found' do
        sign_in user
        put :update, { id: 3123213213, access_token: access_token.token }
        expect(response).to be_not_found
      end
    end
  end

  describe '#mark_all_as_read' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:message2) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }
    let!(:notification2) { FactoryGirl.create(:notification, user: user, actor: actor, content: message2) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :mark_all_as_read, {}, format: :json
        expect(response).to_not be_success
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :mark_all_as_read, {}, format: :json
        expect(response).to_not be_success
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }
      
      it 'marks all notifications as read' do
        sign_in user
        post :mark_all_as_read, { access_token: access_token.token }, format: :json
        expect(notification.reload).to be_read
      end

      it 'marks all notifications as read older than the one passed in, if an id is passed in' do
        sign_in user
        post :mark_all_as_read, { access_token: access_token.token, notification_id: notification.id }, format: :json
        expect(notification.reload).to be_read
        expect(notification2.reload).to_not be_read
      end
    end
  end
end
