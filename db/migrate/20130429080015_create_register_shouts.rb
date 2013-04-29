class CreateRegisterShouts < ActiveRecord::Migration
  def change
    create_table :register_shouts do |t|
      t.references :main
      t.integer :volume, :default => 1
      t.text :message

      t.timestamps
    end
    add_index :register_shouts, :main_id
  end
end
