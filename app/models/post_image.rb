class PostImage < ActiveRecord::Base
  attr_accessible :image
  
  # Paperclip Attributes
  has_attached_file :image,
                    styles: { original: '1280x1280#' },
                    s3_permissions: :public_read,
                    path: "posts/:post_id/post_images/:id.:extension"

  # Relations
  belongs_to :post

  # Callbacks

  # Validations
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

end
