class CreateResultJobs < ActiveRecord::Migration
  def change
    create_table :result_jobs do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :job
      t.string :name
      t.text :caption
      t.integer :lv
      t.integer :lv_exp
      t.integer :lv_cap
      t.integer :lv_cap_exp
      t.boolean :forget

      t.timestamps
    end
    add_index :result_jobs, :character_id
    add_index :result_jobs, :day_id
    add_index :result_jobs, :job_id
  end
end
