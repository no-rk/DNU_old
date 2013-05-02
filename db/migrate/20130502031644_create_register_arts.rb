class CreateRegisterArts < ActiveRecord::Migration
  def change
    create_table :register_arts do |t|
      t.references :user
      t.references :day
      t.references :art

      t.timestamps
    end
    add_index :register_arts, :user_id
    add_index :register_arts, :day_id
    add_index :register_arts, :art_id
  end
end
