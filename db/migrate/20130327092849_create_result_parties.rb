class CreateResultParties < ActiveRecord::Migration
  def change
    create_table :result_parties do |t|
      t.references :day
      t.string :kind
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :result_parties, :day_id
  end
end
