require 'spec_helper'

describe UserCity do
  it { should belong_to(:user) }
  it { should belong_to(:city) }
end
