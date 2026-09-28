class BikesController < ApplicationController
  before_action :set_bike, only: %i[show edit update destroy]

  def index
    @bikes = Bike.includes(:customer).by_make_model
  end

  def show
    @repairs = @bike.repairs.includes(bike: :customer).by_promised_date
  end

  def new
    @bike = Bike.new(params.key?(:bike) ? bike_params : {})
    load_customers
  end

  def edit
    load_customers
  end

  def create
    @bike = Bike.new(bike_params)
    if @bike.save
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was created."
    else
      load_customers
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was updated."
    else
      load_customers
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, notice: "Bike #{@bike.serial_number} was deleted.", status: :see_other
    else
      redirect_to @bike, status: :see_other,
        alert: "Bike #{@bike.serial_number} could not be deleted: #{@bike.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_bike
    @bike = Bike.find(params[:id])
  end

  def load_customers
    @customers = Customer.by_name
  end

  def bike_params
    params.expect(bike: %i[customer_id make model color serial_number])
  end
end
