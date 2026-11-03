class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: %i[show edit update destroy]

  def index
    authorize StaffMember
    @staff_members = policy_scope(StaffMember).by_role_and_name
  end

  def show
    authorize @staff_member
    @repairs = policy_scope(Repair).where(intake_by_staff_id: @staff_member.id)
                     .or(policy_scope(Repair).where(assigned_mechanic_id: @staff_member.id))
                     .with_attached_intake_photos.with_rich_text_diagnosis_and_embeds.includes({ bike: :customer }, :intake_by_staff, user: :staff_member)
                     .by_promised_date
  end

  def new
    authorize StaffMember
    @staff_member = StaffMember.new
  end

  def edit
    authorize @staff_member
  end

  def create
    authorize StaffMember
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      redirect_to @staff_member, notice: "Staff member #{@staff_member.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @staff_member
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: "Staff member #{@staff_member.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @staff_member
    if @staff_member.destroy
      redirect_to staff_members_path, notice: "Staff member #{@staff_member.name} was deleted.", status: :see_other
    else
      redirect_to @staff_member, status: :see_other,
        alert: "Staff member #{@staff_member.name} could not be deleted: #{@staff_member.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end

  def staff_member_params
    params.expect(staff_member: %i[name role])
  end
end
