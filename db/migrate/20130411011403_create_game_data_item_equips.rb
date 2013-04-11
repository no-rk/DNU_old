class CreateGameDataItemEquips < ActiveRecord::Migration
  def change
    create_table :game_data_item_equips do |t|
      t.references :item_type
      t.string :kind
      t.text :definition

      t.timestamps
    end
    add_index :game_data_item_equips, :item_type_id
  end
end
