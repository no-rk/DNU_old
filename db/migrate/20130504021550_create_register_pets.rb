class CreateRegisterPets < ActiveRecord::Migration
  def change
    create_table :register_pets do |t|
      t.references :user
      t.references :day
      t.references :pet

      t.timestamps
    end
    add_index :register_pets, :user_id
    add_index :register_pets, :day_id
    add_index :register_pets, :pet_id
  end
end
