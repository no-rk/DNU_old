class CreateGameDataEventSteps < ActiveRecord::Migration
  def change
    create_table :game_data_event_steps do |t|
      t.references :event
      t.string :name
      t.string :timing
      t.text :condition

      t.timestamps
    end
    add_index :game_data_event_steps, :event_id
  end
end
