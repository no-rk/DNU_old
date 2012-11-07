class CreateRegisterInitJobs < ActiveRecord::Migration
  def change
    create_table :register_init_jobs do |t|
      t.references :initial
      t.references :job

      t.timestamps
    end
    add_index :register_init_jobs, :initial_id
    add_index :register_init_jobs, :job_id
  end
end
