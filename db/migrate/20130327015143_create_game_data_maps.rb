class CreateGameDataMaps < ActiveRecord::Migration
  def change
    create_table :game_data_maps do |t|
      t.string :name
      t.text :caption
      t.string :base

      t.timestamps
    end
  end
end
