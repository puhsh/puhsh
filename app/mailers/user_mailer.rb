class UserMailer < MandrillMailer::TemplateMailer
  include ApplicationHelper
  include PostsHelper
  include MoneyRails::ActionViewExtension
  default from: 'puhsher@puhsh.com'

  def welcome_email(user)
    @user = user
    mandrill_mail template: 'Welcome',
                    to: @user.contact_email,
                    vars: {
                      'USER_FIRST_NAME' => @user.first_name,
                      'USER_EMAIL' => @user.contact_email,
                      'CURRENT_YEAR' => Date.today.year
                    },
                    inline_css: true
  end

  def new_post_email(post)
    @post = post
    @user = @post.user
    @post_url = bitly_url(post_url(@post.city.slug, @user.slug, @post.slug))
    @description = @post.description
    @post_location = post_location_name(@user)
    @image_url = @post.post_images.first.image.url(:small)
    @price = item_price(@post)
    mandrill_mail template: 'item-posted',
                  to: @user.contact_email,
                  vars: {
                    'USER_FIRST_NAME' => @user.first_name,
                    'USER_EMAIL' => @user.contact_email,
                    'POST_TITLE' => @post.title,
                    'CURRENT_YEAR' => Date.today.year,
                    'VIEW_POST_URL' => @post_url,
                    'VIEW_POST_PHOTO' => @image_url,
                    'POST_PRICE' => @price,
                    'POST_DESCRIPTION' => @description,
                    'POST_LOCATION' => @post_location
                  },
                  inline_css: true
  end

  def new_message_email(message)
    @message = message
    @sender = @message.sender
    @recipient = @message.recipient
    mandrill_mail template: 'message-received',
                  to: @recipient.contact_email,
                  vars: {
                    'RECIPIENT_FIRST_NAME' => @recipient.first_name,
                    'RECIPIENT_EMAIL' => @recipient.contact_email,
                    'SENDER_FIRST_NAME' => @sender.first_name,
                    'SENDER_LAST_NAME' => @sender.last_name,
                    'SENDER_AVATAR_URL' => @sender.avatar_url,
                    'MESSAGE_CONTENT' => @message.content,
                    'CURRENT_YEAR' => Date.today.year
                  },
                  inline_css: true

  end

  def new_question_email(question)
    @question = question
    @post = @question.item.post
    @question_user = @question.user
    @post_user = @post.user
    mandrill_mail template: 'comment-posted',
                  to: @post_user.contact_email,
                  vars: {
                    'POST_TITLE' => @post.title,
                    'POST_USER_FIRST_NAME' => @post_user.first_name,
                    'POST_USER_EMAIL' => @post_user.contact_email,
                    'QUESTION_USER_FIRST_NAME' => @question_user.first_name,
                    'QUESTION_USER_LAST_NAME' => @question_user.last_name,
                    'QUESTION_USER_AVATAR_URL' => @question_user.avatar_url,
                    'QUESTION_CONTENT' => @question.content,
                    'CURRENT_YEAR' => Date.today.year
                  },
                  inline_css: true
  end

  def new_question_after_question_email(question, user)
    @question = question
    @post = @question.item.post
    @question_user = @question.user
    @user = user
    mandrill_mail template: 'comment-on-comment',
                  to: @user.contact_email,
                  vars: {
                    'POST_TITLE' => @post.title,
                    'USER_FIRST_NAME' => @user.first_name,
                    'QUESTION_USER_FIRST_NAME' => @question_user.first_name,
                    'QUESTION_USER_LAST_NAME' => @question_user.last_name,
                    'QUESTION_USER_AVATAR_URL' => @question_user.avatar_url,
                    'QUESTION_CONTENT' => @question.content,
                    'CURRENT_YEAR' => Date.today.year
                  },
                  inline_css: true
  end

  def item_purchased(post, user)
    @user = user
    @post = post
    @post_url = bitly_url(post_url(@post.city.slug, @user.slug, @post.slug))
    @price = item_price(@post)
    @image_url = @post.post_images.first.image.url(:small)
    mandrill_mail template: 'item-purchased',
                 to: @user.contact_email,
                 vars: { 
                   'POST_TITLE' => @post.title,
                   'POST_PRICE' => @price,
                   'USER_FIRST_NAME' => @user.first_name,
                   'USER_EMAIL' => @user.contact_email,
                   'VIEW_POST_URL' => @post_url,
                   'VIEW_POST_PHOTO' => @image_url,
                   'CURRENT_YEAR' => Date.today.year
                 }
  end

  def facebook_friend_joined(user_that_joined, user)
    @user_that_joined = user_that_joined
    @user = user
    @user_that_joined_gender = @user_that_joined.gender == 'male' ? 'His' : 'Her'
    mandrill_mail template: 'facebook-friend-joined',
                    to: @user.contact_email,
                    vars: {
                      'USER_FIRST_NAME' => @user.first_name,
                      'USER_EMAIL' => @user.contact_email,
                      'OTHER_USER_AVATAR_URL' =>  @user_that_joined.avatar_url,
                      'OTHER_USER_NAME' => @user_that_joined.name,
                      'GENDER' => @user_that_joined_gender,
                      'CURRENT_YEAR' => Date.today.year
                    }

  end

  private 

  def item_price(post)
    post.item.price_cents > 0 ? humanized_money_with_symbol(post.item.price) : 'FREE'
  end
end
