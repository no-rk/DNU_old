class CreateResultPoints < ActiveRecord::Migration
  def change
    create_table :result_points do |t|
      t.references :passed_day
      t.references :point
      t.integer :value

      t.timestamps
    end
    add_index :result_points, :passed_day_id
    add_index :result_points, :point_id
  end
end
