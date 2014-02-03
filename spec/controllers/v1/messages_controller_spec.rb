require 'spec_helper'

describe V1::MessagesController do
  describe '#index' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:recipient) { FactoryGirl.create(:user) }
    let!(:recipient2) { FactoryGirl.create(:user) }
    let!(:message_sent1) { FactoryGirl.create(:message, sender: user, recipient: recipient, content: 'Test') }
    let!(:message_sent2) { FactoryGirl.create(:message, sender: user, recipient: recipient2, content: 'Test') }
    let!(:message_received1) { FactoryGirl.create(:message, sender: recipient, recipient: user, content: 'Test') }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, {}
        expect(assigns[:messages]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index
        expect(assigns[:messages]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'returns all the messages, grouped by recipients' do
        sign_in user
        get :index, { access_token: access_token.token }
        expect(assigns[:messages]).to include(message_sent1)
        expect(assigns[:messages]).to include(message_sent2)
        expect(assigns[:messages]).to_not include(message_received1)
      end

      it 'returns all the messages between two individuals' do
        sign_in user
        get :index, { access_token: access_token.token, recipient_id: recipient }
        expect(assigns[:messages]).to include(message_sent1)
        expect(assigns[:messages]).to include(message_received1)
      end
    end

  end
end
