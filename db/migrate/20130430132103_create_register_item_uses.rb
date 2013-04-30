class CreateRegisterItemUses < ActiveRecord::Migration
  def change
    create_table :register_item_uses do |t|
      t.references :main
      t.integer :number
      t.text :message

      t.timestamps
    end
    add_index :register_item_uses, :main_id
  end
end
