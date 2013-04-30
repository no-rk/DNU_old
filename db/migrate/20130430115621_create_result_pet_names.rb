class CreateResultPetNames < ActiveRecord::Migration
  def change
    create_table :result_pet_names do |t|
      t.references :pet
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.string :name
      t.text :caption
      t.references :source

      t.timestamps
    end
    add_index :result_pet_names, :pet_id
    add_index :result_pet_names, :user_id
    add_index :result_pet_names, :day_id
    add_index :result_pet_names, :way_id
    add_index :result_pet_names, :source_id
  end
end
