class AllowIntakeWithoutStaffMember < ActiveRecord::Migration[8.1]
  def change
    change_column_null :repairs, :intake_by_staff_id, true
  end
end
