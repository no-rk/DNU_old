class CreateRegisterDuels < ActiveRecord::Migration
  def change
    create_table :register_duels do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_duels, :user_id
    add_index :register_duels, :day_id
  end
end
