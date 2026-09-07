class CreateRepairs < ActiveRecord::Migration[8.1]
  def change
    create_table :repairs do |t|
      t.bigint :bike_id, null: false
      t.bigint :intake_by_staff_id, null: false
      t.bigint :assigned_mechanic_id
      t.string :status, default: "Received", null: false
      t.date :promised_on, null: false
      t.boolean :approved_by_customer
      t.datetime :completed_at
      t.datetime :picked_up_at

      t.timestamps
    end

    add_index :repairs, :bike_id
    add_index :repairs, :intake_by_staff_id
    add_index :repairs, :assigned_mechanic_id
    add_index :repairs, :status
  end
end
