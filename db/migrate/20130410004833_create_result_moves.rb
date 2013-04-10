class CreateResultMoves < ActiveRecord::Migration
  def change
    create_table :result_moves do |t|
      t.references :user
      t.references :day
      t.integer :direction
      t.references :from
      t.references :to
      t.boolean :success

      t.timestamps
    end
    add_index :result_moves, :user_id
    add_index :result_moves, :day_id
    add_index :result_moves, :from_id
    add_index :result_moves, :to_id
  end
end
