class UserMailer < MandrillMailer::TemplateMailer
  default from: "no-reply@puhsh.com"
  
  def welcome_email(user)
    @user = user
    mandrill_mail template: 'Welcome',
                    to: user.contact_email,
                    vars: { 
                      'USER_FIRST_NAME' => user.first_name,
                      'USER_EMAIL' => user.contact_email,
                      'CURRENT_YEAR' => Date.today.year
                    }
  end

  def new_post_email(post)
    @post = post
    @user = post.user
  end
end
