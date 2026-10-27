require "test_helper"

class AccessControlAndRepairsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @staff = StaffMember.create!(name: "Intake Agent", role: "Counter Staff")
    @user.update!(staff_member: @staff)

    @customer = Customer.create!(name: "Test Customer", phone: "+56 9 1234 5678")
    @bike = Bike.create!(customer: @customer, make: "Trek", model: "Marlin", color: "Blue", serial_number: "SN-TEST-INT")
    @service = Service.create!(name: "Basic Tune", description: "Tune up", standard_price: 30.00)
  end

  test "public pages are accessible without session" do
    get services_path
    assert_response :success

    get service_path(@service)
    assert_response :success

    get new_session_path
    assert_response :success

    get new_registration_path
    assert_response :success

    get new_password_path
    assert_response :success
  end

  test "closed pages redirect visitor to sign in" do
    get root_path
    assert_redirected_to new_session_path

    get customers_path
    assert_redirected_to new_session_path

    get bikes_path
    assert_redirected_to new_session_path

    get repairs_path
    assert_redirected_to new_session_path

    get staff_members_path
    assert_redirected_to new_session_path

    get new_service_path
    assert_redirected_to new_session_path
  end

  test "friendly forwarding lands on originally requested page after sign in" do
    get repairs_path
    assert_redirected_to new_session_path

    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to repairs_url
  end

  test "repair intake records account from session and ignores forged params" do
    sign_in_as(@user)

    other_user = users(:two)

    assert_difference "Repair.count", 1 do
      post repairs_path, params: {
        repair: {
          bike_id: @bike.id,
          intake_by_staff_id: @staff.id,
          status: "Received",
          promised_on: 2.days.from_now.to_date,
          user_id: other_user.id
        }
      }
    end

    repair = Repair.last
    assert_equal @user, repair.user, "Must assign current session user, ignoring user_id param"

    # Verify repair page shows who took it in
    get repair_path(repair)
    assert_response :success
    assert_select "dd", text: /Intake Agent/

    # Editing repair does not alter the intake user
    patch repair_path(repair), params: {
      repair: {
        status: "Diagnosed",
        user_id: other_user.id
      }
    }
    assert_equal @user, repair.reload.user
  end

  test "repair intake displays user email when user has no staff member" do
    solo_user = User.create!(
      email_address: "independent@wheelhouse.cl",
      password: "Password1234!",
      password_confirmation: "Password1234!",
      staff_member: nil
    )
    sign_in_as(solo_user)

    post repairs_path, params: {
      repair: {
        bike_id: @bike.id,
        intake_by_staff_id: @staff.id,
        status: "Received",
        promised_on: 2.days.from_now.to_date
      }
    }

    repair = Repair.last
    assert_equal solo_user, repair.user

    get repair_path(repair)
    assert_response :success
    assert_select "dd", text: /independent@wheelhouse.cl/
  end

  test "repairs index query count is fixed and avoids N+1 queries" do
    sign_in_as(@user)

    # Create initial batch of 5 repairs
    5.times do |i|
      Repair.create!(
        bike: @bike,
        intake_by_staff: @staff,
        user: (i.even? ? @user : nil),
        status: "Received",
        promised_on: (i + 1).days.from_now.to_date
      )
    end

    initial_queries = 0
    counter = ->(name, start, finish, id, payload) {
      initial_queries += 1 unless payload[:name] == "SCHEMA" || payload[:sql] =~ /SAVEPOINT|RELEASE/
    }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
      get repairs_path
    end
    assert_response :success

    # Add 10 more repairs (total 15) with varied users
    10.times do |i|
      Repair.create!(
        bike: @bike,
        intake_by_staff: @staff,
        user: (i.even? ? @user : nil),
        status: "Received",
        promised_on: (i + 1).days.from_now.to_date
      )
    end

    doubled_queries = 0
    counter = ->(name, start, finish, id, payload) {
      doubled_queries += 1 unless payload[:name] == "SCHEMA" || payload[:sql] =~ /SAVEPOINT|RELEASE/
    }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
      get repairs_path
    end
    assert_response :success

    assert_equal initial_queries, doubled_queries, "Repairs index query count must not increase when repairs are added"
  end


  test "api v1 routes work with token and without session" do
    previous_api = Rails.application.credentials.api
    Rails.application.credentials.api = { token: "integration-test-token" }
    header = { "Authorization" => "Bearer integration-test-token" }

    begin
      get "/api/v1/services", headers: header
      assert_response :success
      assert_nil cookies[:session_id]

      get "/api/v1/repairs", headers: header
      assert_response :success
      assert_nil cookies[:session_id]
    ensure
      Rails.application.credentials.api = previous_api
    end
  end
end
