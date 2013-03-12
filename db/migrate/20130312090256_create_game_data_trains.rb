class CreateGameDataTrains < ActiveRecord::Migration
  def change
    create_table :game_data_trains do |t|
      t.references :trainable, :polymorphic => true
      t.boolean :visible

      t.timestamps
    end
    add_index :game_data_trains, :trainable_id
  end
end
