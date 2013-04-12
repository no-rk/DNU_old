class CreateResultBattleValues < ActiveRecord::Migration
  def change
    create_table :result_battle_values do |t|
      t.references :passed_day
      t.references :battle_value
      t.integer :value

      t.timestamps
    end
    add_index :result_battle_values, :passed_day_id
    add_index :result_battle_values, :battle_value_id
  end
end
