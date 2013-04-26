class CreateGameDataCharacters < ActiveRecord::Migration
  def change
    create_table :game_data_characters do |t|
      t.string :kind
      t.string :name
      t.text :definition
      t.text :tree

      t.timestamps
    end
  end
end
