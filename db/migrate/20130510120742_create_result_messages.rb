class CreateResultMessages < ActiveRecord::Migration
  def change
    create_table :result_messages do |t|
      t.references :passed_day
      t.references :message
      t.text :html
      t.string :ancestry

      t.timestamps
    end
    add_index :result_messages, :passed_day_id
    add_index :result_messages, :message_id
    add_index :result_messages, :ancestry
  end
end
