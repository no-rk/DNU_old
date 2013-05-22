class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :namespace
      t.string :room
      t.text :data

      t.timestamps
    end
  end
end
