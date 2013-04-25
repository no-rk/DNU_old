class CreateGameDataEquips < ActiveRecord::Migration
  def change
    create_table :game_data_equips do |t|
      t.references :item_type
      t.string :kind
      t.string :name
      t.text :definition

      t.timestamps
    end
    add_index :game_data_equips, :item_type_id
  end
end
