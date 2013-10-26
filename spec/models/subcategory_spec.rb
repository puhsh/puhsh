require 'spec_helper'

describe Subcategory do
  it { should have_many(:posts) } 
  it { should belong_to(:category) } 

  describe '.status' do
    let(:subcategory) { FactoryGirl.create(:subcategory) }

    it 'is active by default' do
      expect(subcategory).to be_active
    end

    it 'can be made inactive' do
      subcategory.status = :inactive
      subcategory.save
      expect(subcategory.reload).to be_inactive
    end
  end

  describe '.name' do
    let(:subcategory) { FactoryGirl.create(:subcategory) }

    it 'is required' do
      subcategory.name = nil
      subcategory.save
      expect(subcategory).to_not be_valid
    end
  end
end
