require 'spec_helper'

describe V1::InvitesController do

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { invites: [{ user_id: user.id, uid_invited: '123456' }] }, format: :json
        expect(assigns[:invites]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { invites: [{ user_id: user.id, uid_invited: '123456' }] }, format: :json
        expect(assigns[:invites]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let(:access_token2) { FactoryGirl.create(:access_token, user: user2) }

      it 'creates an invite' do
        sign_in user
        post :create, { invites: [{ user_id: user.id, uid_invited: '123456' }], access_token: access_token.token }, format: :json
        expect(user.reload.invites.each_cons(user.reload.invites.size)).to include(assigns[:invites])
      end

      it 'creates multiple invites' do
        sign_in user
        post :create, { invites: [{ user_id: user.id, uid_invited: '123456' }, {user_id: user.id, uid_invited: '654321'}], access_token: access_token.token }, format: :json
        expect(assigns[:invites]).to eql(user.reload.invites.to_a)
      end

      it 'creates multiple invites but ignores duplicates' do
        FactoryGirl.create(:invite, user_id: user.id, uid_invited: '654321')
        sign_in user
        post :create, { invites: [{ user_id: user.id, uid_invited: '123456' }, {user_id: user.id, uid_invited: '654321'}], access_token: access_token.token }, format: :json
        expect(user.reload.invites.size).to eql(2)
        expect(assigns[:invites].size).to eql(1)
      end

      it 'creates multiple invites and does not ignore duplicates when the user id is different' do
        FactoryGirl.create(:invite, user_id: user.id, uid_invited: '123456')
        sign_in user2
        post :create, { invites: [{ user_id: user2.id, uid_invited: '123456' }], access_token: access_token2.token }, format: :json
        expect(user2.reload.invites.to_a).to eql(assigns[:invites])
      end
    end
  end
end
