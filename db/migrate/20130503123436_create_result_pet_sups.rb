class CreateResultPetSups < ActiveRecord::Migration
  def change
    create_table :result_pet_sups do |t|
      t.references :pet
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.integer :number
      t.references :sup
      t.integer :lv
      t.references :source

      t.timestamps
    end
    add_index :result_pet_sups, :pet_id
    add_index :result_pet_sups, :user_id
    add_index :result_pet_sups, :day_id
    add_index :result_pet_sups, :way_id
    add_index :result_pet_sups, :sup_id
    add_index :result_pet_sups, :source_id
  end
end
