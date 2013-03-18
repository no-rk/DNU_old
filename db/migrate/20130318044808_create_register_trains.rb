class CreateRegisterTrains < ActiveRecord::Migration
  def change
    create_table :register_trains do |t|
      t.references :main
      t.references :train

      t.timestamps
    end
    add_index :register_trains, :main_id
    add_index :register_trains, :train_id
  end
end
