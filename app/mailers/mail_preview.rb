class MailPreview < MailView
  def confirmation_instructions
    user = User.first
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token)
  end
end
