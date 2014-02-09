class UserMailer < MandrillMailer::TemplateMailer
  default from: "no-reply@puhsh.com"
  
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
    @post_url = ''
    mandrill_mail template: 'item-posted',
                  to: @user.contact_email,
                  vars: {
                    'USER_FIRST_NAME' => @user.first_name,
                    'USER_EMAIL' => @user.contact_email,
                    'POST_TITLE' => @post.title,
                    'CURRENT_YEAR' => Date.today.year
                  },
                  inline_css: true
  end

  def new_message_email(message)
    @message = message
    @sender = @message.sender
    @recipient = @message.recipient
    mandrill_mail template: 'message-received',
                  vars: {
                    'RECIPIENT_FIRST_NAME' => @recipient.first_name,
                    'RECIPIENT_EMAIL' => @recipient.contact_email,
                    'SENDER_FIRST_NAME' => @sender.first_name,
                    'SENDER_LAST_NAME' => @sender.last_name,
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
                  vars: {
                    'POST_USER_FIRST_NAME' => @post_user.first_name,
                    'POST_USER_EMAIL' => @post_user.contact_email,
                    'QUESTION_USER_FIRST_NAME' => @question_user.first_name,
                    'QUESTION_USER_LAST_NAME' => @question_user.last_name,
                    'QUESTION_CONTENT' => @question.content,
                    'CURRENT_YEAR' => Date.today.year
                  },
                  inline_css: true
  end
end