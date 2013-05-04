class CreateResultEventForms < ActiveRecord::Migration
  def change
    create_table :result_event_forms do |t|
      t.references :passed_day
      t.references :event_content

      t.timestamps
    end
    add_index :result_event_forms, :passed_day_id
    add_index :result_event_forms, :event_content_id
  end
end
