require 'spec_helper'

describe Zipcode do
  it { should belong_to(:city) }
end
