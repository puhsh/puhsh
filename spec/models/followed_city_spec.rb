require 'spec_helper'

describe FollowedCity do
  it { should belong_to(:user) }
  it { should belong_to(:city) }
end
