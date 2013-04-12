class CreateResultStatuses < ActiveRecord::Migration
  def change
    create_table :result_statuses do |t|
      t.references :passed_day
      t.references :status
      t.string :name
      t.text :caption
      t.integer :count
      t.integer :bonus

      t.timestamps
    end
    add_index :result_statuses, :passed_day_id
    add_index :result_statuses, :status_id
  end
end
