class CreateGameDataLandforms < ActiveRecord::Migration
  def change
    create_table :game_data_landforms do |t|
      t.string :name
      t.text :caption
      t.string :image
      t.string :color
      t.boolean :collision, :default => false
      t.integer :opacity, :default => 0

      t.timestamps
    end
  end
end
