s3_credentials = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env].symbolize_keys
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:s3_credentials] = s3_credentials
Paperclip::Attachment.default_options[:s3_protocol] = 'http'
Paperclip::Attachment.default_options[:s3_permissions] = :private

Paperclip.interpolates :post_id do |attachment, style|
  attachment.instance.post.id
end
