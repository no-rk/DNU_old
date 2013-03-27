class CreateResultPlaces < ActiveRecord::Migration
  def change
    create_table :result_places do |t|
      t.references :user
      t.references :day
      t.references :map_tip

      t.timestamps
    end
    add_index :result_places, :user_id
    add_index :result_places, :day_id
    add_index :result_places, :map_tip_id
  end
end
