class CreateGameDataSerifSettings < ActiveRecord::Migration
  def change
    create_table :game_data_serif_settings do |t|
      t.string :kind
      t.string :name
      t.text :caption
      t.text :condition

      t.timestamps
    end
  end
end
