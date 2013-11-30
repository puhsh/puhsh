require 'spec_helper'

describe Item do
  it { should belong_to(:post) }
<<<<<<< HEAD:spec/models/item_spec.rb
  it { should have_many(:offers) }
=======
  it { should have_attached_file(:image) }
>>>>>>> Specs:spec/models/post_image_spec.rb
end
