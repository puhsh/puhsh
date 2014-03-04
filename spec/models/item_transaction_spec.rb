require 'spec_helper'

describe ItemTransaction do
  it { should belong_to(:seller) }
  it { should belong_to(:buyer) }
  it { should belong_to(:post) }
  it { should belong_to(:item) }
  it { should belong_to(:offer) }
end
