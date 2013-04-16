class CreateResultSupplements < ActiveRecord::Migration
  def change
    create_table :result_supplements do |t|
      t.references :passed_day
      t.references :supplement
      t.references :from
      t.references :to
      t.references :item_sup
      t.boolean :success

      t.timestamps
    end
    add_index :result_supplements, :passed_day_id
    add_index :result_supplements, :supplement_id
    add_index :result_supplements, :from_id
    add_index :result_supplements, :to_id
    add_index :result_supplements, :item_sup_id
  end
end
