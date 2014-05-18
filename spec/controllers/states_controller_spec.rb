require 'spec_helper'

describe StatesController do
  context '#index' do
    let!(:city) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
    let!(:city2) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
    let!(:city3) { FactoryGirl.create(:city, state: 'CA', full_state_name: 'California') }

    it 'finds the US States' do
      get :index, format: :html
      expect(assigns[:states]).to_not be_empty

      expect(assigns[:states].collect(&:full_state_name)).to include('Texas')
      expect(assigns[:states].collect(&:full_state_name)).to include('California')
    end
  end

  context '#show' do
    let!(:city) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
    let!(:city2) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
    let!(:city3) { FactoryGirl.create(:city, state: 'CA', full_state_name: 'California') }

    it 'finds the cities in the state' do
      get :show, { name: 'texas' },  format: :html
      expect(assigns[:cities]).to include(city)
      expect(assigns[:cities]).to include(city2)
      expect(assigns[:cities]).to_not include(city3)
    end

    it 'stores the currenty state name' do
      get :show, { name: 'texas' },  format: :html
      expect(assigns[:current_state_name]).to eql('Texas')
    end
  end
end
