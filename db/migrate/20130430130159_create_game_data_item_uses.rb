class CreateGameDataItemUses < ActiveRecord::Migration
  def change
    create_table :game_data_item_uses do |t|
      t.string :name
      t.text :definition
      t.text :tree

      t.timestamps
    end
  end
end
