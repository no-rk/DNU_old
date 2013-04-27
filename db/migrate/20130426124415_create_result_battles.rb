class CreateResultBattles < ActiveRecord::Migration
  def change
    create_table :result_battles do |t|
      t.references :notice
      t.text :html
      t.text :tree

      t.timestamps
    end
    add_index :result_battles, :notice_id
  end
end
