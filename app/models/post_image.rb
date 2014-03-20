class PostImage < ActiveRecord::Base
  attr_accessible :image
  
  # Paperclip Attributes
  has_attached_file :image,
                    styles: { original: '1280x1280#', medium: '640x640#', small: '320x320#' },
                    s3_permissions: :public_read,
                    path: "posts/:post_id/post_images/:slug-:id-:style.:extension"

  # Relations
  belongs_to :post

  # Callbacks

  # Validations
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/jpg', 'image/png']

  # Methods

  def image_urls
    {
      small: self.image.url(:small),
      medium: self.image.url(:medium),
      large: self.image.url(:large)
    }
  end

end
