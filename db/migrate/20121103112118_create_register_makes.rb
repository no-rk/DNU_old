class CreateRegisterMakes < ActiveRecord::Migration
  def change
    create_table :register_makes do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_makes, :user_id
  end
end
