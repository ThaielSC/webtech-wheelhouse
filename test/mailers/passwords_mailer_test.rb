require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  def default_url_options = { host: "example.com" }

  test "reset" do
    user = users(:one)
    mail = PasswordsMailer.reset(user)

    assert_includes mail.subject, "Wheelhouse"
    assert_includes mail.subject, "Reset your password"
    assert_equal [ user.email_address ], mail.to

    assert mail.html_part.present?
    assert mail.text_part.present?

    assert_includes mail.html_part.body.to_s, "Wheelhouse"
    assert_includes mail.html_part.body.to_s, "/passwords/"
    assert_includes mail.html_part.body.to_s, "/edit"

    assert_includes mail.text_part.body.to_s, "Wheelhouse"
    assert_includes mail.text_part.body.to_s, "/passwords/"
    assert_includes mail.text_part.body.to_s, "/edit"
  end
end
