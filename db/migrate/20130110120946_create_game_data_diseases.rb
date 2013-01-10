class CreateGameDataDiseases < ActiveRecord::Migration
  def change
    create_table :game_data_diseases do |t|
      t.string :name
      t.text :caption
      t.string :color

      t.timestamps
    end
  end
end
