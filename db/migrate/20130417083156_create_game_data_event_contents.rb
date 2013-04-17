class CreateGameDataEventContents < ActiveRecord::Migration
  def change
    create_table :game_data_event_contents do |t|
      t.references :event_step
      t.string :kind
      t.text :content

      t.timestamps
    end
    add_index :game_data_event_contents, :event_step_id
  end
end
