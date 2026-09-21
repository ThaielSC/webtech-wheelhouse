class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_role_and_name
  end

  def show
    @staff_member = StaffMember.find(params[:id])
    @repairs = Repair.where(intake_by_staff_id: @staff_member.id)
                     .or(Repair.where(assigned_mechanic_id: @staff_member.id))
                     .includes(bike: :customer)
                     .by_promised_date
  end
end
