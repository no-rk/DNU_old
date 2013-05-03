class CreateGameDataArts < ActiveRecord::Migration
  def change
    create_table :game_data_arts do |t|
      t.references :art_type
      t.string :kind
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :game_data_arts, :art_type_id
  end
end
