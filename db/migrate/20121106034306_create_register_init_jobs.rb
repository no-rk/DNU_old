class CreateRegisterInitJobs < ActiveRecord::Migration
  def change
    create_table :register_init_jobs do |t|
      t.references :initial
      t.string :name

      t.timestamps
    end
    add_index :register_init_jobs, :initial_id
  end
end
