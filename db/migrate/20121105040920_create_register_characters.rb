class CreateRegisterCharacters < ActiveRecord::Migration
  def change
    create_table :register_characters do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_characters, :user_id
  end
end
