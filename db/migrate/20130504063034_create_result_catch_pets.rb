class CreateResultCatchPets < ActiveRecord::Migration
  def change
    create_table :result_catch_pets do |t|
      t.references :passed_day
      t.references :catch_pet
      t.integer :number
      t.references :pet
      t.boolean :success

      t.timestamps
    end
    add_index :result_catch_pets, :passed_day_id
    add_index :result_catch_pets, :catch_pet_id
    add_index :result_catch_pets, :pet_id
  end
end
