class CreateRegisterDiaries < ActiveRecord::Migration
  def change
    create_table :register_diaries do |t|
      t.references :main
      t.text :diary

      t.timestamps
    end
    add_index :register_diaries, :main_id
  end
end
