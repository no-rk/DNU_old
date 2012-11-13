class CreateRegisterInitGuardians < ActiveRecord::Migration
  def change
    create_table :register_init_guardians do |t|
      t.references :initial
      t.references :guardian

      t.timestamps
    end
    add_index :register_init_guardians, :initial_id
    add_index :register_init_guardians, :guardian_id
  end
end
