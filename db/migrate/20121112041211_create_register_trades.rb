class CreateRegisterTrades < ActiveRecord::Migration
  def change
    create_table :register_trades do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_trades, :user_id
    add_index :register_trades, :day_id
  end
end
