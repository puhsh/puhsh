require 'spec_helper'

describe Category do
  it { should have_many(:posts) }

  describe '.status' do
    let(:category) { FactoryGirl.create(:category) }

    it 'is active by default' do
      expect(category).to be_active
    end

    it 'can be made inactive' do
      category.status = :inactive
      category.save
      expect(category.reload).to be_inactive
    end
  end
end
