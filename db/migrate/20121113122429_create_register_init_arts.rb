class CreateRegisterInitArts < ActiveRecord::Migration
  def change
    create_table :register_init_arts do |t|
      t.references :initial
      t.references :art

      t.timestamps
    end
    add_index :register_init_arts, :initial_id
    add_index :register_init_arts, :art_id
  end
end
