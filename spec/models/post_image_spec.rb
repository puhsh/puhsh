require 'spec_helper'

describe PostImage do
  it { should belong_to(:post) }
  it { should have_attached_file(:image) }
end
