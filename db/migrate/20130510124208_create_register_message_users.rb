class CreateRegisterMessageUsers < ActiveRecord::Migration
  def change
    create_table :register_message_users do |t|
      t.references :message
      t.references :parent
      t.references :user
      t.text :body

      t.timestamps
    end
    add_index :register_message_users, :message_id
    add_index :register_message_users, :parent_id
    add_index :register_message_users, :user_id
  end
end
