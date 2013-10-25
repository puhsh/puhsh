require 'spec_helper'

describe City do
  it { should have_many(:users) }
  it { should have_many(:users).through(:followed_cities) }
  it { should have_many(:posts) }
end
