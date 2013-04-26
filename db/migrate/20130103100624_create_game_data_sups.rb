class CreateGameDataSups < ActiveRecord::Migration
  def change
    create_table :game_data_sups do |t|
      t.string :name
      t.text :definition
      t.text :tree

      t.timestamps
    end
  end
end
