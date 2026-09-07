class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :standard_price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :services, :name, unique: true
  end
end
