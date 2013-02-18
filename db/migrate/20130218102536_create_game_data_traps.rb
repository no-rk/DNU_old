class CreateGameDataTraps < ActiveRecord::Migration
  def change
    create_table :game_data_traps do |t|
      t.string :name
      t.text :definition

      t.timestamps
    end
  end
end
