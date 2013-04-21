class CreateGameDataEvents < ActiveRecord::Migration
  def change
    create_table :game_data_events do |t|
      t.string :kind
      t.string :name
      t.text :caption
      t.text :definition

      t.timestamps
    end
  end
end
