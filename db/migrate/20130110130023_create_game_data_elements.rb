class CreateGameDataElements < ActiveRecord::Migration
  def change
    create_table :game_data_elements do |t|
      t.string :name
      t.text :caption
      t.string :color
      t.string :anti

      t.timestamps
    end
  end
end
