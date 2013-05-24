class CreateResultMessageUsers < ActiveRecord::Migration
  def change
    create_table :result_message_users do |t|
      t.references :passed_day
      t.references :message_user
      t.text :html
      t.string :ancestry

      t.timestamps
    end
    add_index :result_message_users, :passed_day_id
    add_index :result_message_users, :message_user_id
    add_index :result_message_users, :ancestry
  end
end
