class CreateGameDataWeapons < ActiveRecord::Migration
  def change
    create_table :game_data_weapons do |t|
      t.string :name
      t.text :definition

      t.timestamps
    end
  end
end
