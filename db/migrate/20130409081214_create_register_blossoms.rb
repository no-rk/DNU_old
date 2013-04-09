class CreateRegisterBlossoms < ActiveRecord::Migration
  def change
    create_table :register_blossoms do |t|
      t.references :main
      t.references :train

      t.timestamps
    end
    add_index :register_blossoms, :main_id
    add_index :register_blossoms, :train_id
  end
end
