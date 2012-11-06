class CreateRegisterInitials < ActiveRecord::Migration
  def change
    create_table :register_initials do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_initials, :user_id
  end
end
