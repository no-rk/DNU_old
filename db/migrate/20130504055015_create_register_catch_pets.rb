class CreateRegisterCatchPets < ActiveRecord::Migration
  def change
    create_table :register_catch_pets do |t|
      t.references :event
      t.references :character
      t.integer :correction

      t.timestamps
    end
    add_index :register_catch_pets, :event_id
    add_index :register_catch_pets, :character_id
  end
end
