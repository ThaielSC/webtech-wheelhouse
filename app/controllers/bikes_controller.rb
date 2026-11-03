class BikesController < ApplicationController
  before_action :set_bike, only: %i[show edit update destroy]

  def index
    authorize Bike
    @bikes = policy_scope(Bike).includes(:customer).by_make_model
  end

  def show
    authorize @bike
    @repairs = policy_scope(@bike.repairs).with_attached_intake_photos.with_rich_text_diagnosis_and_embeds
      .includes({ bike: :customer }, :intake_by_staff, user: :staff_member).by_promised_date
  end

  def new
    authorize Bike
    @bike = Bike.new(params.key?(:bike) ? bike_params : {})
    load_customers
  end

  def edit
    authorize @bike
    load_customers
  end

  def create
    authorize Bike
    @bike = Bike.new(bike_params)
    if @bike.save
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was created."
    else
      load_customers
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @bike
    if @bike.update(bike_params)
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was updated."
    else
      load_customers
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @bike
    if @bike.destroy
      redirect_to bikes_path, notice: "Bike #{@bike.serial_number} was deleted.", status: :see_other
    else
      redirect_to @bike, status: :see_other,
        alert: "Bike #{@bike.serial_number} could not be deleted: #{@bike.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_bike
    @bike = Bike.includes(:customer).find(params[:id])
  end

  def load_customers
    @customers = Customer.by_name
  end

  def bike_params
    params.expect(bike: %i[customer_id make model color serial_number])
  end
end
