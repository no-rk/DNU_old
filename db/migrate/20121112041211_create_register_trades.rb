class CreateRegisterTrades < ActiveRecord::Migration
  def change
    create_table :register_trades do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_trades, :user_id
  end
end
