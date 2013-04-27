class CreateResultDisposes < ActiveRecord::Migration
  def change
    create_table :result_disposes do |t|
      t.references :passed_day
      t.references :dispose
      t.references :item
      t.boolean :success

      t.timestamps
    end
    add_index :result_disposes, :passed_day_id
    add_index :result_disposes, :dispose_id
    add_index :result_disposes, :item_id
  end
end
