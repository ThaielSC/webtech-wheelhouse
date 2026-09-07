class CreateRepairItems < ActiveRecord::Migration[8.1]
  def change
    create_table :repair_items do |t|
      t.bigint :repair_id, null: false
      t.bigint :service_id, null: false
      t.decimal :charged_price, precision: 8, scale: 2, null: false
      t.text :notes

      t.timestamps
    end

    add_index :repair_items, :repair_id
    add_index :repair_items, :service_id
  end
end
