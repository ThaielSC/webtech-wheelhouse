require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  setup do
    @previous_api = Rails.application.credentials.api
    Rails.application.credentials.api = { token: "integration-test-token" }
    @headers = { "Authorization" => "Bearer integration-test-token", "Accept" => "text/html" }
    @service = Service.create!(name: "<b>API tune-up</b>", description: "Adjustment", standard_price: "35.20")
    customer = Customer.create!(name: "API customer", phone: "private")
    bike = Bike.create!(customer: customer, make: "Trek", model: "Marlin", color: "blue", serial_number: "API-001")
    staff = StaffMember.create!(name: "API staff", role: "Mechanic")
    @repair = Repair.create!(bike: bike, intake_by_staff: staff, promised_on: Date.current + 2)
    2.times { @repair.repair_items.create!(service: @service, charged_price: "30.10") }
  end

  teardown do
    Rails.application.credentials.api = @previous_api
  end

  test "public service documents have one explicit shape and reads do not write" do
    assert_no_difference [ "Service.count", "Repair.count", "RepairItem.count" ] do
      get api_v1_services_path, headers: { "Accept" => "text/html" }
      assert_response :ok
      assert_equal "application/json", response.media_type
      document = response.parsed_body.find { |service| service["id"] == @service.id }
      assert_equal({ "id" => @service.id, "name" => @service.name, "standard_price" => "35.20", "repairs_count" => 1 }, document)
      assert_equal Service.by_name.pluck(:id), response.parsed_body.map { |service| service["id"] }
      get api_v1_service_path(@service, format: :xml)
      assert_equal document, response.parsed_body
      assert_nil response.headers["Set-Cookie"]
    end
  end

  test "private routes require only a bearer header before doing work" do
    [ nil, "Bearer wrong", "Token integration-test-token" ].each do |authorization|
      headers = authorization ? { "Authorization" => authorization } : {}
      get api_v1_repairs_path, params: { token: "integration-test-token" }, headers: headers
      assert_error :unauthorized
      get api_v1_repair_path(@repair), headers: headers
      assert_error :unauthorized
      assert_no_difference "Service.count" do
        post api_v1_services_path, params: { token: "integration-test-token" }, as: :json, headers: headers
        assert_error :unauthorized
      end
    end
  end

  test "repairs include accounting data without private or unrelated data" do
    get api_v1_repair_path(@repair), headers: @headers
    assert_response :ok
    document = response.parsed_body
    assert_equal "60.20", document["total"]
    assert_equal false, document["overdue"]
    assert_nil document["approved_by_customer"]
    assert_nil document["handed_back_on"]
    assert_equal({ "name" => "API customer" }, document["customer"])
    assert_equal({ "brand" => "Trek", "model" => "Marlin", "serial_number" => "API-001" }, document["bike"])
    assert_equal [ { "service_name" => @service.name, "charged_price" => "30.10" } ] * 2, document["lines"]
    assert_no_match(/phone|_id|diagnosis|notes|staff|photos/, response.body)
    Repair.statuses.each_key do |state|
      get api_v1_repairs_path, params: { state: state }, headers: @headers
      assert_response :ok
      assert response.parsed_body.all? { |repair| repair["state"] == state }
    end
    get api_v1_repairs_path, params: { state: "unknown" }, headers: @headers
    assert_error :bad_request
    Repair.statuses.each_key { |state| assert_includes response.parsed_body["errors"].join, state }
  end

  test "creation uses strong parameters and matches public document" do
    assert_difference "Service.count", 1 do
      post api_v1_services_path, params: { service: { name: "New API service", description: "Description", standard_price: "12.34", id: 987654 } }, headers: @headers, as: :json
      assert_response :created
    end
    document = response.parsed_body
    assert_not_equal 987654, document["id"]
    assert_equal 0, document["repairs_count"]
    assert_equal "12.34", document["standard_price"]
    get response.headers["Location"]
    assert_equal document, response.parsed_body
  end

  test "all specified errors are JSON arrays including malformed and empty bodies" do
    get api_v1_service_path(0), headers: @headers
    assert_error :not_found
    get api_v1_repair_path(0), headers: @headers
    assert_error :not_found
    get "/api/v1/missing", headers: @headers
    assert_error :not_found
    [ {}, { service: {} }, { service: { ignored: true } }, { service: "wrong" } ].each do |body|
      post api_v1_services_path, params: body, headers: @headers, as: :json
      assert_error :bad_request
    end
    post api_v1_services_path, headers: @headers
    assert_error :bad_request
    post api_v1_services_path, params: '{"service":', headers: @headers.merge("Content-Type" => "application/json")
    assert_error :bad_request
    invalid = { name: "", description: "", standard_price: "-1" }
    post api_v1_services_path, params: { service: invalid }, headers: @headers, as: :json
    assert_error :unprocessable_entity
    model = Service.new(invalid)
    model.valid?
    assert_equal model.errors.full_messages, response.parsed_body["errors"]
  end

  test "CORS opens only public GET services for the two page origins" do
    [ "https://thaielsc.github.io", "http://localhost:5500" ].each do |origin|
      get api_v1_services_path, headers: { "Origin" => origin }
      assert_equal origin, response.headers["Access-Control-Allow-Origin"]
      get api_v1_service_path(@service), headers: { "Origin" => origin }
      assert_equal origin, response.headers["Access-Control-Allow-Origin"]
      get api_v1_repairs_path, headers: @headers.merge("Origin" => origin)
      assert_nil response.headers["Access-Control-Allow-Origin"]
      options api_v1_services_path, headers: { "Origin" => origin, "Access-Control-Request-Method" => "POST" }
      assert_nil response.headers["Access-Control-Allow-Origin"]
    end
    get api_v1_services_path, headers: { "Origin" => "https://other.example" }
    assert_nil response.headers["Access-Control-Allow-Origin"]
    get api_v1_services_path
    assert_response :ok
  end

  test "collection query counts stay constant as repairs and lines grow" do
    get api_v1_repairs_path, headers: @headers
    get api_v1_services_path
    repairs_before = queries_for { get api_v1_repairs_path, headers: @headers }
    services_before = queries_for { get api_v1_services_path }
    3.times do |index|
      repair = Repair.create!(bike: @repair.bike, intake_by_staff: @repair.intake_by_staff, promised_on: Date.current + 3)
      service = Service.create!(name: "Extra #{index}", description: "Extra", standard_price: "20.00")
      3.times { repair.repair_items.create!(service: service, charged_price: "10.00") }
    end
    assert_equal repairs_before, queries_for { get api_v1_repairs_path, headers: @headers }
    assert_equal services_before, queries_for { get api_v1_services_path }
    assert_equal 5, repairs_before
    assert_equal 2, services_before
  end

  private

  def assert_error(status)
    assert_response status
    assert_equal "application/json", response.media_type
    assert_equal [ "errors" ], response.parsed_body.keys
    assert response.parsed_body["errors"].all? { |error| error.is_a?(String) }
    assert_not_empty response.parsed_body["errors"]
  end

  def queries_for
    queries = []
    subscriber = ->(event) do
      queries << event.payload[:sql] unless event.payload[:name].in?([ "SCHEMA", "CACHE" ]) || event.payload[:sql].match?(/\A(?:BEGIN|COMMIT|SAVEPOINT|RELEASE)/)
    end
    ActiveRecord::Base.uncached do
      ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") { yield }
    end
    queries.size
  end
end
