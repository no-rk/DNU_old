class CreateRegisterMains < ActiveRecord::Migration
  def change
    create_table :register_mains do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_mains, :user_id
    add_index :register_mains, :day_id
  end
end
