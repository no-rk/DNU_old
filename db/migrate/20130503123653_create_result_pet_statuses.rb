class CreateResultPetStatuses < ActiveRecord::Migration
  def change
    create_table :result_pet_statuses do |t|
      t.references :pet
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.references :status
      t.integer :count
      t.integer :bonus
      t.references :source

      t.timestamps
    end
    add_index :result_pet_statuses, :pet_id
    add_index :result_pet_statuses, :user_id
    add_index :result_pet_statuses, :day_id
    add_index :result_pet_statuses, :way_id
    add_index :result_pet_statuses, :status_id
    add_index :result_pet_statuses, :source_id
  end
end
