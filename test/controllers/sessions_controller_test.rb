require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
    assert_select "form[action='#{session_path}']"
    assert_select "label[for='email_address']"
    assert_select "label[for='password']"
    assert_select "a[href='#{new_registration_path}']", text: "Create an account"
  end

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]

    cookie = response.cookies["session_id"]
    # Check Set-Cookie attributes
    set_cookie_header = response.headers["Set-Cookie"].to_s
    assert_match(/httponly/i, set_cookie_header)
    assert_match(/samesite=lax/i, set_cookie_header)
  end

  test "wrong email address and wrong password show the exact same message" do
    post session_path, params: { email_address: "nonexistent@example.com", password: "password" }
    assert_redirected_to new_session_path
    wrong_email_flash = flash[:alert]

    post session_path, params: { email_address: @user.email_address, password: "wrong-password" }
    assert_redirected_to new_session_path
    wrong_password_flash = flash[:alert]

    assert_equal wrong_email_flash, wrong_password_flash
    assert_equal "Try another email address or password.", wrong_password_flash
  end

  test "destroy is not a GET and lands on sign-in page" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end

  test "visitor navbar shows price list and sign in, but no protected links" do
    get services_path
    assert_response :success

    assert_select "nav .navbar-nav a[href='#{services_path}']", text: "Price list"
    assert_select "nav .navbar-nav a[href='#{new_session_path}']", text: "Sign in"
    assert_select "nav .navbar-nav a[href='#{customers_path}']", count: 0
    assert_select "nav .navbar-nav a[href='#{repairs_path}']", count: 0
    assert_select "nav .navbar-nav a[href='#{bikes_path}']", count: 0
    assert_select "nav .navbar-nav a[href='#{staff_members_path}']", count: 0
  end

  test "authenticated navbar shows staff or email, role, and sign out button" do
    staff = StaffMember.create!(name: "Elena Tester", role: "Mechanic")
    user = User.create!(
      email_address: "elena.tester@wheelhouse.cl",
      password: "Password1234!",
      password_confirmation: "Password1234!",
      role: :mechanic,
      staff_member: staff
    )
    sign_in_as(user)

    get root_path
    assert_response :success

    assert_select "nav .navbar-text", text: /Elena Tester/
    assert_select "nav .navbar-text .badge", text: user.role.titleize
    assert_select "nav form[action='#{session_path}'] input[value='delete'][name='_method'], nav button[type='submit']"
  end
end
