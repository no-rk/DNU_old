class CreateGameDataPointUses < ActiveRecord::Migration
  def change
    create_table :game_data_point_uses do |t|
      t.references :point
      t.boolean :status
      t.references :art_type

      t.timestamps
    end
    add_index :game_data_point_uses, :point_id
    add_index :game_data_point_uses, :art_type_id
  end
end
