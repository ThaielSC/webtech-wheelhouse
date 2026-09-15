class AddForeignKeysToWorkshopTables < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :bikes, :customers

    add_foreign_key :repairs, :bikes
    add_foreign_key :repairs, :staff_members, column: :intake_by_staff_id
    add_foreign_key :repairs, :staff_members, column: :assigned_mechanic_id

    add_foreign_key :repair_items, :repairs
    add_foreign_key :repair_items, :services
  end
end
