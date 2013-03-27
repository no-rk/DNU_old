class CreateResultStatuses < ActiveRecord::Migration
  def change
    create_table :result_statuses do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :status
      t.integer :count

      t.timestamps
    end
    add_index :result_statuses, :character_id
    add_index :result_statuses, :day_id
    add_index :result_statuses, :status_id
  end
end
