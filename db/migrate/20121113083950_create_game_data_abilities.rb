class CreateGameDataAbilities < ActiveRecord::Migration
  def change
    create_table :game_data_abilities do |t|
      t.string :name
      t.text :caption
      t.text :definition

      t.timestamps
    end
  end
end
