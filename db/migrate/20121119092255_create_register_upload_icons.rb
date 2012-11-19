class CreateRegisterUploadIcons < ActiveRecord::Migration
  def change
    create_table :register_upload_icons do |t|
      t.references :image
      t.string :icon
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :register_upload_icons, :image_id
  end
end
