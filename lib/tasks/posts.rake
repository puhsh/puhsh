namespace :posts do
  desc 'Re-save post images. Useful if the path changed'
  task :resave_images => :environment do
    s3 = AWS::S3.new(YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env].symbolize_keys)
    bucket = s3.buckets["puhsh_#{Rails.env.to_s}"]
    puts "Current Bucket: #{bucket.name}"
    bucket.objects.each do |object|
      current_key = object.key
      post_image_id = current_key.split("/").last.split(".").first # what a hack but it gets the job done. quickly gets the post image id
      post_image = PostImage.find_by_id(post_image_id)
      if post_image
        new_key = post_image.image.path
        new_object = bucket.objects[new_key]
        object.copy_to new_object, {acl: :public_read}
      end
    end
  end


  desc 'Store post user ids in cities'
  task :store_user_ids_for_cities => :environment do
    Post.includes(:city).find_each do |post|
      post.send(:store_users_who_have_posted_for_city)
    end
  end
end
