class CreateGameDataCharacterTypes < ActiveRecord::Migration
  def change
    create_table :game_data_character_types do |t|
      t.string :name
      t.text :caption

      t.timestamps
    end
  end
end
