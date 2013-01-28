class CreateGameDataLearningConditions < ActiveRecord::Migration
  def change
    create_table :game_data_learning_conditions do |t|
      t.references :learnable, :polymorphic => true
      t.integer :condition_group
      t.integer :group_count
      t.string :name
      t.integer :lv

      t.timestamps
    end
    add_index :game_data_learning_conditions, :learnable_id
  end
end
