class CreateResultEvents < ActiveRecord::Migration
  def change
    create_table :result_events do |t|
      t.references :passed_day
      t.references :event
      t.string :state

      t.timestamps
    end
    add_index :result_events, :passed_day_id
    add_index :result_events, :event_id
  end
end
