class CreateResultShouts < ActiveRecord::Migration
  def change
    create_table :result_shouts do |t|
      t.references :day
      t.references :map_tip
      t.references :shout

      t.timestamps
    end
    add_index :result_shouts, :day_id
    add_index :result_shouts, :map_tip_id
    add_index :result_shouts, :shout_id
  end
end
