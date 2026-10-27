require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
    assert_select "form[action='#{registration_path}']"
    assert_select "input[name='user[email_address]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
  end

  test "create creates account with default role, signs in, and enqueues welcome email" do
    assert_difference "User.count", 1 do
      assert_enqueued_emails 1 do
        post registration_path, params: {
          user: {
            email_address: "newbie@wheelhouse.cl",
            password: "SecurePassword123!",
            password_confirmation: "SecurePassword123!"
          }
        }
      end
    end

    user = User.find_by!(email_address: "newbie@wheelhouse.cl")
    assert_predicate user, :mechanic?
    assert_nil user.staff_member
    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create ignores hand-crafted role or staff_member params" do
    staff = StaffMember.create!(name: "Innocent Staff", role: "Mechanic")

    post registration_path, params: {
      user: {
        email_address: "hacker@wheelhouse.cl",
        password: "SecurePassword123!",
        password_confirmation: "SecurePassword123!",
        role: "owner",
        staff_member_id: staff.id
      }
    }

    user = User.find_by!(email_address: "hacker@wheelhouse.cl")
    assert_predicate user, :mechanic?, "Must have default role mechanic"
    assert_nil user.staff_member, "Must not allow setting staff member"
  end

  test "refused sign up renders form with 422, keeps email, blanks passwords, sends no email" do
    assert_no_difference "User.count" do
      assert_enqueued_emails 0 do
        post registration_path, params: {
          user: {
            email_address: "invalid-email",
            password: "short",
            password_confirmation: "short"
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert_select "input[name='user[email_address]'][value='invalid-email']"
    assert_select "input[name='user[password]'][value='']"
    assert_select "input[name='user[password_confirmation]'][value='']"
    assert_select ".invalid-feedback, .alert-danger"
  end
end
