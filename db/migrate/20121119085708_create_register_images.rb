class CreateRegisterImages < ActiveRecord::Migration
  def change
    create_table :register_images do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_images, :user_id
  end
end
