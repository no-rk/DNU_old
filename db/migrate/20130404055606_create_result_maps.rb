class CreateResultMaps < ActiveRecord::Migration
  def change
    create_table :result_maps do |t|
      t.references :day
      t.references :map
      t.binary :image, :limit => 1.megabyte

      t.timestamps
    end
    add_index :result_maps, :day_id
    add_index :result_maps, :map_id
  end
end
