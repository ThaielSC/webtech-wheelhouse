class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Wheelhouse: Reset your password", to: user.email_address
  end
end
