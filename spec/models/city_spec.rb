require 'spec_helper'

describe City do
  it { should have_many(:user_cities) }
  it { should have_many(:users).through(:user_cities) }
end
