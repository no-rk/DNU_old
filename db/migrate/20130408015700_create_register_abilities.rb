class CreateRegisterAbilities < ActiveRecord::Migration
  def change
    create_table :register_abilities do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_abilities, :user_id
    add_index :register_abilities, :day_id
  end
end
