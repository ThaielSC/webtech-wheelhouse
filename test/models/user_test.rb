require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "default role is mechanic" do
    user = User.new
    assert_predicate user, :mechanic?
  end

  test "valid roles are owner, mechanic, and counter" do
    assert_equal %w[owner mechanic counter], User.roles.keys
  end

  test "refuses duplicate email address case insensitively" do
    existing = users(:one)
    duplicate = User.new(
      email_address: existing.email_address.upcase,
      password: "ValidPassword123!",
      password_confirmation: "ValidPassword123!"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "refuses invalid email format" do
    user = User.new(email_address: "not-an-email", password: "ValidPassword123!")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "refuses password shorter than 10 characters with explicit message" do
    user = User.new(
      email_address: "unique@wheelhouse.cl",
      password: "short",
      password_confirmation: "short"
    )
    assert_not user.valid?
    assert_includes user.errors[:password], "must be at least 10 characters long"
  end

  test "allows account without staff member" do
    user = User.new(
      email_address: "freelancer@wheelhouse.cl",
      password: "ValidPassword123!",
      password_confirmation: "ValidPassword123!",
      staff_member: nil
    )
    assert user.valid?
  end

  test "refuses a second account for the same staff member" do
    staff = StaffMember.create!(name: "Test Staff", role: "Mechanic")
    User.create!(
      email_address: "staff1@wheelhouse.cl",
      password: "ValidPassword123!",
      password_confirmation: "ValidPassword123!",
      staff_member: staff
    )

    duplicate_account = User.new(
      email_address: "staff2@wheelhouse.cl",
      password: "ValidPassword123!",
      password_confirmation: "ValidPassword123!",
      staff_member: staff
    )

    assert_not duplicate_account.valid?
    assert_includes duplicate_account.errors[:staff_member_id], "has already been taken"
  end

  test "staff member with an account cannot be destroyed" do
    staff = StaffMember.create!(name: "Protected Staff", role: "Mechanic")
    User.create!(
      email_address: "protected@wheelhouse.cl",
      password: "ValidPassword123!",
      password_confirmation: "ValidPassword123!",
      staff_member: staff
    )

    assert_no_difference "StaffMember.count" do
      staff.destroy
    end
    assert_includes staff.errors[:base], "Cannot delete record because a dependent user exists"
  end
end
