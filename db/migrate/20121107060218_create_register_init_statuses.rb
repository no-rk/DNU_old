class CreateRegisterInitStatuses < ActiveRecord::Migration
  def change
    create_table :register_init_statuses do |t|
      t.references :initial
      t.references :status
      t.integer :count

      t.timestamps
    end
    add_index :register_init_statuses, :initial_id
    add_index :register_init_statuses, :status_id
  end
end
