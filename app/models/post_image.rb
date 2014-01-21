class PostImage < ActiveRecord::Base
  attr_accessible :image
  
  # Paperclip Attributes
  has_attached_file :image,
                    styles: {},
                    path: "posts/:post_id/post_images/:id.png"

  # Relations
  belongs_to :post

  # Callbacks

  # Validations

end
