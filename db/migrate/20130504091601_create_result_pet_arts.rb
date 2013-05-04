class CreateResultPetArts < ActiveRecord::Migration
  def change
    create_table :result_pet_arts do |t|
      t.references :pet
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.integer :number
      t.references :art
      t.integer :lv
      t.references :source

      t.timestamps
    end
    add_index :result_pet_arts, :pet_id
    add_index :result_pet_arts, :user_id
    add_index :result_pet_arts, :day_id
    add_index :result_pet_arts, :way_id
    add_index :result_pet_arts, :art_id
    add_index :result_pet_arts, :source_id
  end
end
