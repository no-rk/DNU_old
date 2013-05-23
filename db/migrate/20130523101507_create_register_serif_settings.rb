class CreateRegisterSerifSettings < ActiveRecord::Migration
  def change
    create_table :register_serif_settings do |t|
      t.references :battlable, :polymorphic => true
      t.references :serif_setting
      t.text :message

      t.timestamps
    end
    add_index :register_serif_settings, :battlable_id
    add_index :register_serif_settings, :serif_setting_id
  end
end
