class CreateResultBlossoms < ActiveRecord::Migration
  def change
    create_table :result_blossoms do |t|
      t.references :passed_day
      t.references :blossomable, :polymorphic => true
      t.boolean :success

      t.timestamps
    end
    add_index :result_blossoms, :passed_day_id
    add_index :result_blossoms, :blossomable_id
  end
end
