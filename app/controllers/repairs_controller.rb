class RepairsController < ApplicationController
  before_action :set_repair, only: %i[show edit update destroy destroy_photo]

  def index
    authorize Repair
    @repairs = policy_scope(Repair).with_attached_intake_photos.with_rich_text_diagnosis_and_embeds
      .includes({ bike: :customer }, :intake_by_staff, user: :staff_member)
    @repairs = @repairs.where(status: Repair.statuses[params[:state]]) if Repair.statuses.key?(params[:state])
    @repairs = @repairs.overdue if params[:overdue] == "1"
    @repairs = @repairs.by_promised_date
  end



  def show
    authorize @repair
    @repair_items = @repair.repair_items.sort_by { |item| [ item.service.name, item.id ] }
  end

  def new
    authorize Repair
    @repair = Repair.new(params.key?(:repair) ? repair_params : {})
    prepare_form
  end

  def edit
    authorize @repair
    prepare_form
  end

  def create
    authorize Repair
    @repair = Repair.new(repair_params)
    @repair.user = Current.user
    @repair.intake_by_staff = Current.user.staff_member
    if @repair.save

      redirect_to @repair, notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was created."
    else
      prepare_form
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @repair
    attributes = repair_params
    photos = attributes.delete(:intake_photos).to_a.reject(&:blank?)
    @repair.assign_attributes(attributes)
    @repair.intake_photos = @repair.intake_photos.blobs.to_a + photos if photos.any?

    if @repair.save
      redirect_to @repair, notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was updated.", status: :see_other
    else
      prepare_form
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_photo
    authorize @repair
    @repair.intake_photos_attachments.find(params[:attachment_id]).purge
    redirect_to @repair, notice: "Intake photo removed.", status: :see_other
  end

  def destroy
    authorize @repair
    blobs = @repair.intake_photos.blobs.to_a
    if @repair.destroy
      blobs.each(&:purge)
      redirect_to repairs_path, status: :see_other,
        notice: "Repair ##{@repair.id} for bike #{@repair.bike.serial_number} was deleted."
    else
      redirect_to @repair, status: :see_other,
        alert: "Repair ##{@repair.id} could not be deleted: #{@repair.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_repair
    @repair = Repair.with_attached_intake_photos.with_rich_text_diagnosis_and_embeds.includes(
      { bike: :customer }, :intake_by_staff, :assigned_mechanic, { repair_items: :service }, user: :staff_member
    ).find(params[:id])
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
    [ required_empty_lines - empty_line_count, 0 ].max.times { @repair.repair_items.build }
  end

  def repair_params
    params.expect(repair: policy(@repair || Repair).permitted_attributes)
  end
end
