require 'spec_helper'

describe Follow do
  it { should belong_to(:user) }
  it { should belong_to(:followed_user) }
end
