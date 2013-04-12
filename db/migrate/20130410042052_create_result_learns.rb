class CreateResultLearns < ActiveRecord::Migration
  def change
    create_table :result_learns do |t|
      t.references :passed_day
      t.references :learnable, :polymorphic => true
      t.boolean :first

      t.timestamps
    end
    add_index :result_learns, :passed_day_id
    add_index :result_learns, :learnable_id
  end
end
