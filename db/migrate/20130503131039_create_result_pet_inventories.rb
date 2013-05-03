class CreateResultPetInventories < ActiveRecord::Migration
  def change
    create_table :result_pet_inventories do |t|
      t.references :passed_day
      t.references :character_type
      t.string :kind
      t.integer :number
      t.references :pet

      t.timestamps
    end
    add_index :result_pet_inventories, :passed_day_id
    add_index :result_pet_inventories, :character_type_id
    add_index :result_pet_inventories, :pet_id
  end
end
