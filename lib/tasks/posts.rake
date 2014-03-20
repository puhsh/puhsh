namespace :posts do
  desc 'Re-save post images. Useful if the path changed'
  task :resave_images => :environment do
    s3 = AWS::S3.new(YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env].symbolize_keys)
    bucket = s3.buckets["puhsh_#{Rails.env.to_s}"]
    puts "Current Bucket: #{bucket.name}"
    bucket.objects.each do |object|
      current_key = object.key
      post_image_id = current_key.split("/").last.split(".").first # what a hack but it gets the job done. quickly gets the post image id
      post_image = PostImage.find(post_image_id)
      new_key = post_image.image.path
      new_object = bucket.objects[new_key]
      object.copy_to new_object, {acl: :public_read}
    end
  end
end
