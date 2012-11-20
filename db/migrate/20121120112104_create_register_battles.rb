class CreateRegisterBattles < ActiveRecord::Migration
  def change
    create_table :register_battles do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_battles, :user_id
  end
end
