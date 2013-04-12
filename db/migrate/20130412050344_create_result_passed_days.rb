class CreateResultPassedDays < ActiveRecord::Migration
  def change
    create_table :result_passed_days do |t|
      t.references :user
      t.references :day
      t.integer :passed_day

      t.timestamps
    end
    add_index :result_passed_days, :user_id
    add_index :result_passed_days, :day_id
  end
end
