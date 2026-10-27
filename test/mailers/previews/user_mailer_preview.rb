# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    user = User.take || User.new(email_address: "ana@wheelhouse.cl")
    UserMailer.welcome(user)
  end
end
