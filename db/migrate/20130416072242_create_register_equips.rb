class CreateRegisterEquips < ActiveRecord::Migration
  def change
    create_table :register_equips do |t|
      t.references :battlable, :polymorphic => true
      t.string :kind
      t.integer :number

      t.timestamps
    end
    add_index :register_equips, :battlable_id
  end
end
