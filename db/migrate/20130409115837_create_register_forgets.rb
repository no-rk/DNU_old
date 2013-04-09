class CreateRegisterForgets < ActiveRecord::Migration
  def change
    create_table :register_forgets do |t|
      t.references :main
      t.references :train

      t.timestamps
    end
    add_index :register_forgets, :main_id
    add_index :register_forgets, :train_id
  end
end
