require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  def default_url_options = { host: "example.com" }

  test "welcome" do
    user = User.new(email_address: "ana@wheelhouse.cl")
    mail = UserMailer.welcome(user)

    assert_equal "Welcome to Wheelhouse", mail.subject
    assert_equal [ "ana@wheelhouse.cl" ], mail.to
    assert_equal [ "from@example.com" ], mail.from

    # Check both text and html parts
    assert mail.html_part.present?
    assert mail.text_part.present?

    assert_includes mail.html_part.body.to_s, "ana@wheelhouse.cl"
    assert_includes mail.html_part.body.to_s, new_session_url
    assert_includes mail.html_part.body.to_s, "Wheelhouse"

    assert_includes mail.text_part.body.to_s, "ana@wheelhouse.cl"
    assert_includes mail.text_part.body.to_s, new_session_url
    assert_includes mail.text_part.body.to_s, "Wheelhouse"
  end
end
