require "spec_helper"

describe UserMailer do
  let!(:user) { FactoryGirl.create(:user, contact_email: 'test@test.local') }

  describe '.welcome_email' do
    let!(:mail) { UserMailer.welcome_email(user).deliver }
    before { MandrillMailer.deliveries.clear }

    it 'sends the email' do
    end

  end
end
