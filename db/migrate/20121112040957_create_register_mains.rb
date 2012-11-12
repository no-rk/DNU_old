class CreateRegisterMains < ActiveRecord::Migration
  def change
    create_table :register_mains do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_mains, :user_id
  end
end
