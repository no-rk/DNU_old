class CreateGameDataItems < ActiveRecord::Migration
  def change
    create_table :game_data_items do |t|
      t.string :kind
      t.string :name
      t.text :definition

      t.timestamps
    end
  end
end
