class CreateResultSendPoints < ActiveRecord::Migration
  def change
    create_table :result_send_points do |t|
      t.references :user
      t.references :day
      t.references :send_point
      t.boolean :success

      t.timestamps
    end
    add_index :result_send_points, :user_id
    add_index :result_send_points, :day_id
    add_index :result_send_points, :send_point_id
  end
end
