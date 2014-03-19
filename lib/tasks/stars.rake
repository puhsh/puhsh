namespace :stars do
  desc 'Associates star reccords to their missing subjects'
  task :find_and_add_subjects => :environment do
    User.find_each do |user|
      # New Account
      Star.where(user_id: user.id, event: :new_account).update_all(subject_id: user.id, subject_type: 'User')

      # Invites
      invites = Invite.where(user_id: user.id)
      friend_stars = Star.where(user_id: user.id, event: 'friend_invite')

      invites.each_with_index do |invite, index|
        star = friend_stars[index]
        star.subject_id = invite.id
        star.subject_type = 'Invite'
        star.save
      end

      # Post
      posts = Post.where(user_id: user.id)
      post_stars = Star.where(user_id: user.id, event: :new_post)

      posts.each_with_index do |post, index|
        star = post_stars[index]
        star.subject_id = post.id
        star.subject_type = 'Post'
        star.save
      end
      
      # Wall Post
      wall_posts = WallPost.where(user_id: user.id)
      wall_stars = Star.where(user_id: user.id).where('event in (?)', [:shared_sms, :shared_wall_post])

      wall_posts.each_with_index do |wall_post, index|
        star = wall_stars[index]
        star.subject_id = wall_post.id
        star.subject_type = 'WallPost'
        star.save
      end
    end
  end
end
