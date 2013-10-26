require 'spec_helper'

describe AccessToken do

  it { should belong_to(:user) }

  describe '.token' do
    let(:user) { FactoryGirl.create(:user) }
    let(:access_token) { FactoryGirl.build(:access_token, user: user) }
    let!(:existing_access_token) { FactoryGirl.create(:access_token, user: user) }

    it 'is generated after a save' do
      access_token.save
      expect(access_token.reload.token).to_not be_nil
    end

    it 'is not generated after a save if the token is still valid' do
      existing_access_token.save
      expect(existing_access_token.reload.token).to eql(existing_access_token.token)
    end
  end

  describe '.expired?' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:existing_access_token) { FactoryGirl.create(:access_token, user: user) }

    it 'if it has been two weeks' do
      Timecop.travel(Date.today + 3.weeks) do
        expect(existing_access_token).to be_expired
      end
    end
  end
end
