require 'spec_helper'

describe City do
  it { should have_many(:users) }
  it { should have_many(:followed_cities) }
  it { should have_many(:users).through(:followed_cities) }
  it { should have_many(:posts) }
  it { should have_many(:zipcodes) }
end
