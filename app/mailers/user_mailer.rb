class UserMailer < MandrillMailer::TemplateMailer
  default from: "no-reply@puhsh.com"
  
  def welcome_email(user)
    @user = user
    mandrill_mail template: 'Welcome Email',
                    to: user.contact_email
  end

  def new_post_email(post)
    @post = post
    @user = post.user
  end
end
