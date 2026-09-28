class RepairsController < ApplicationController
  before_action :set_repair, only: %i[show edit update destroy]

  def index
    @repairs = Repair.includes(bike: :customer).by_promised_date
  end

  def show
    @repair_items = @repair.repair_items.includes(:service).by_service_name
  end

  def new
    @repair = Repair.new(params.key?(:repair) ? repair_params : {})
    prepare_form
  end

  def edit
    prepare_form
  end

  def create
    @repair = Repair.new(repair_params)
    if @repair.save
      redirect_to @repair, notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was created."
    else
      prepare_form
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @repair.update(repair_params)
      redirect_to @repair, notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was updated."
    else
      prepare_form
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path, status: :see_other,
        notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was deleted."
    else
      redirect_to @repair, status: :see_other,
        alert: "Repair ##{@repair.id} could not be deleted: #{@repair.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_repair
    @repair = Repair.find(params[:id])
  end

  def prepare_form
    @bikes = Bike.includes(:customer).by_make_model
    @intake_staff_members = StaffMember.by_role_and_name
    @mechanics = StaffMember.mechanics.by_role_and_name
    @services = Service.by_name

    empty_line_count = @repair.repair_items.count do |repair_item|
      repair_item.new_record? && repair_item.service_id.blank?
    end
    required_empty_lines = @repair.persisted? ? 1 : 2
    [required_empty_lines - empty_line_count, 0].max.times { @repair.repair_items.build }
  end

  def repair_params
    params.expect(repair: [
      :bike_id, :intake_by_staff_id, :assigned_mechanic_id, :status, :promised_on,
      :approved_by_customer, :completed_at, :picked_up_at,
      { repair_items_attributes: [[:id, :service_id, :charged_price, :notes, :_destroy]] }
    ])
  end
end
