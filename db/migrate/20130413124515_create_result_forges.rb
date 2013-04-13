class CreateResultForges < ActiveRecord::Migration
  def change
    create_table :result_forges do |t|
      t.references :passed_day
      t.references :forge
      t.references :from
      t.references :to
      t.boolean :success

      t.timestamps
    end
    add_index :result_forges, :passed_day_id
    add_index :result_forges, :forge_id
    add_index :result_forges, :from_id
    add_index :result_forges, :to_id
  end
end
