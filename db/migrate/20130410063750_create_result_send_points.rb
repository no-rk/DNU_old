class CreateResultSendPoints < ActiveRecord::Migration
  def change
    create_table :result_send_points do |t|
      t.references :passed_day
      t.references :send_point
      t.boolean :success

      t.timestamps
    end
    add_index :result_send_points, :passed_day_id
    add_index :result_send_points, :send_point_id
  end
end
