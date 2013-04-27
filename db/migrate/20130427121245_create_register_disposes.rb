class CreateRegisterDisposes < ActiveRecord::Migration
  def change
    create_table :register_disposes do |t|
      t.references :main
      t.integer :number

      t.timestamps
    end
    add_index :register_disposes, :main_id
  end
end
