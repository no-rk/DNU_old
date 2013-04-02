class CreateResultStatuses < ActiveRecord::Migration
  def change
    create_table :result_statuses do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :status
      t.string :name
      t.text :caption
      t.integer :count
      t.integer :bonus

      t.timestamps
    end
    add_index :result_statuses, :character_id
    add_index :result_statuses, :day_id
    add_index :result_statuses, :status_id
  end
end
