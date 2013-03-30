class CreateResultPoints < ActiveRecord::Migration
  def change
    create_table :result_points do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :point
      t.integer :value

      t.timestamps
    end
    add_index :result_points, :character_id
    add_index :result_points, :day_id
    add_index :result_points, :point_id
  end
end
