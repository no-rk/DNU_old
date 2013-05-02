class CreateRegisterArtNames < ActiveRecord::Migration
  def change
    create_table :register_art_names do |t|
      t.references :art
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :register_art_names, :art_id
  end
end
