require 'spec_helper'

describe Item do
  it { should belong_to(:post) }
  it { should have_many(:offers) }
  it { should have_many(:questions) }
end
