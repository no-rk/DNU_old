class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.integer :day
      t.integer :state, :default => 0

      t.timestamps
    end
  end
end
