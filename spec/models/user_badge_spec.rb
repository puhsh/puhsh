require 'spec_helper'

describe UserBadge do
  it { should belong_to(:user) } 
  it { should belong_to(:badge) } 
end
