class CreateResultForgets < ActiveRecord::Migration
  def change
    create_table :result_forgets do |t|
      t.references :passed_day
      t.references :forgettable, :polymorphic => true
      t.integer :lv
      t.boolean :success

      t.timestamps
    end
    add_index :result_forgets, :passed_day_id
    add_index :result_forgets, :forgettable_id
  end
end
