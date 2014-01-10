require 'spec_helper'

describe Follow do
  it { should belong_to(:user) }
  it { should belong_to(:followed_user) }

  describe '.store_user_ids_for_users' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }

    it 'stores the user ids for the respective user' do
      Follow.create(user_id: user.id, followed_user_id: user2.id)
      expect(user.reload.user_ids_followed.members).to include(user2.id.to_s)
      expect(user2.reload.user_ids_following_self.members).to include(user.id.to_s)
    end
  end

end
