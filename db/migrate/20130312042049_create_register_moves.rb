class CreateRegisterMoves < ActiveRecord::Migration
  def change
    create_table :register_moves do |t|
      t.references :main
      t.integer :direction

      t.timestamps
    end
    add_index :register_moves, :main_id
  end
end
