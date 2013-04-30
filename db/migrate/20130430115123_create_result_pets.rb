class CreateResultPets < ActiveRecord::Migration
  def change
    create_table :result_pets do |t|
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.references :plan
      t.references :kind
      t.boolean :dispose_protect
      t.boolean :send_protect
      t.references :source

      t.timestamps
    end
    add_index :result_pets, :user_id
    add_index :result_pets, :day_id
    add_index :result_pets, :way_id
    add_index :result_pets, :plan_id
    add_index :result_pets, :kind_id
    add_index :result_pets, :source_id
  end
end
