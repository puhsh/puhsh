require 'spec_helper'

describe PostImage do
  it { should belong_to(:post) }
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }
end
