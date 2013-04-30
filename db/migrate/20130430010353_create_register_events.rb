class CreateRegisterEvents < ActiveRecord::Migration
  def change
    create_table :register_events do |t|
      t.references :user
      t.references :day
      t.references :event_content

      t.timestamps
    end
    add_index :register_events, :user_id
    add_index :register_events, :day_id
    add_index :register_events, :event_content_id
  end
end
