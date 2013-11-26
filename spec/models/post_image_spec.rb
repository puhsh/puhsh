require 'spec_helper'

describe PostImage do
  it { should belong_to(:post) }
end
