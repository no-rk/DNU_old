class CreateResultEventStates < ActiveRecord::Migration
  def change
    create_table :result_event_states do |t|
      t.references :event
      t.references :event_step
      t.string :state

      t.timestamps
    end
    add_index :result_event_states, :event_id
    add_index :result_event_states, :event_step_id
  end
end
