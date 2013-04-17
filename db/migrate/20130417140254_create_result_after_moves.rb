class CreateResultAfterMoves < ActiveRecord::Migration
  def change
    create_table :result_after_moves do |t|
      t.references :passed_day
      t.references :event_content

      t.timestamps
    end
    add_index :result_after_moves, :passed_day_id
    add_index :result_after_moves, :event_content_id
  end
end
