class CreateGameDataDiseases < ActiveRecord::Migration
  def change
    create_table :game_data_diseases do |t|
      t.string :name
      t.string :color
      t.text :caption
      t.text :definition
      t.text :tree

      t.timestamps
    end
  end
end
