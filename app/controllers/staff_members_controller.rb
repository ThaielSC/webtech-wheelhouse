class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: %i[show edit update destroy]

  def index
    @staff_members = StaffMember.by_role_and_name
  end

  def show
    @repairs = Repair.where(intake_by_staff_id: @staff_member.id)
                     .or(Repair.where(assigned_mechanic_id: @staff_member.id))
                     .includes(bike: :customer)
                     .by_promised_date
  end

  def new
    @staff_member = StaffMember.new
  end

  def edit
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      redirect_to @staff_member, notice: "Staff member #{@staff_member.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: "Staff member #{@staff_member.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
