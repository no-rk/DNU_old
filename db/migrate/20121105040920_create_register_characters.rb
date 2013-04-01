class CreateRegisterCharacters < ActiveRecord::Migration
  def change
    create_table :register_characters do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_characters, :user_id
    add_index :register_characters, :day_id
  end
end
