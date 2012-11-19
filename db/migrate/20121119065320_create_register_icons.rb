class CreateRegisterIcons < ActiveRecord::Migration
  def change
    create_table :register_icons do |t|
      t.references :character
      t.references :upload_icon
      t.string :url
      t.integer :number
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :register_icons, :character_id
    add_index :register_icons, :upload_icon_id
  end
end
