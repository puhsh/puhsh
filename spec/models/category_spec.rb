require 'spec_helper'

describe Category do
  it { should have_many(:posts) }
  it { should have_many(:subcategories) }

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

  describe '.name' do
    let(:category) { FactoryGirl.create(:category) }

    it 'is required' do
      category.name = nil
      category.save
      expect(category).to_not be_valid
    end
  end
end
