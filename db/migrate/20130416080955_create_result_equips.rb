class CreateResultEquips < ActiveRecord::Migration
  def change
    create_table :result_equips do |t|
      t.references :passed_day
      t.references :equip
      t.references :inventory
      t.boolean :success

      t.timestamps
    end
    add_index :result_equips, :passed_day_id
    add_index :result_equips, :equip_id
    add_index :result_equips, :inventory_id
  end
end
