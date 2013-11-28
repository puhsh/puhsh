class PostImage < ActiveRecord::Base
  attr_accessible :image
  
  # Paperclip Attributes
  IMAGE_FILE_DIRECTORY = "#{Rails.env.development? ? Etc.getlogin + '/posts' : 'posts'}"
  has_attached_file :image,
                    styles: {},
                    storage: :s3,
                    s3_credentials: @s3_creds,
                    s3_protocol: 'http',
                    s3_permissions: :private,
                    path: "/#{IMAGE_FILE_DIRECTORY}/:post_id/post_images/:id.png"

  # Relations
  belongs_to :post

  # Callbacks

  # Validations
  validates_attachment :image, presence: true

end
