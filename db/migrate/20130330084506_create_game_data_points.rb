class CreateGameDataPoints < ActiveRecord::Migration
  def change
    create_table :game_data_points do |t|
      t.string :name
      t.text :caption
      t.boolean :non_negative
      t.boolean :protect
      t.string :train

      t.timestamps
    end
  end
end
