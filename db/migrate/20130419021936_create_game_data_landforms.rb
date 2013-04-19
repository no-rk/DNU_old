class CreateGameDataLandforms < ActiveRecord::Migration
  def change
    create_table :game_data_landforms do |t|
      t.string :name
      t.text :caption
      t.string :image
      t.string :color
      t.boolean :collision
      t.integer :opacity

      t.timestamps
    end
  end
end
