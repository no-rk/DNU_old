class CreateRegisterSendPoints < ActiveRecord::Migration
  def change
    create_table :register_send_points do |t|
      t.references :trade
      t.references :point
      t.references :user
      t.integer :value
      t.text :message

      t.timestamps
    end
    add_index :register_send_points, :trade_id
    add_index :register_send_points, :point_id
    add_index :register_send_points, :user_id
  end
end
