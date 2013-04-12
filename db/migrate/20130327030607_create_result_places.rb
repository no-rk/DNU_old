class CreateResultPlaces < ActiveRecord::Migration
  def change
    create_table :result_places do |t|
      t.references :passed_day
      t.references :map_tip
      t.boolean :arrival

      t.timestamps
    end
    add_index :result_places, :passed_day_id
    add_index :result_places, :map_tip_id
  end
end
