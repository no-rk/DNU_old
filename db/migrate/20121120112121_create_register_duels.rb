class CreateRegisterDuels < ActiveRecord::Migration
  def change
    create_table :register_duels do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_duels, :user_id
  end
end
