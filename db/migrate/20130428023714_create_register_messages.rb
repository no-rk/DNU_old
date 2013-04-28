class CreateRegisterMessages < ActiveRecord::Migration
  def change
    create_table :register_messages do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_messages, :user_id
    add_index :register_messages, :day_id
  end
end
