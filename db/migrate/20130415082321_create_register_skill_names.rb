class CreateRegisterSkillNames < ActiveRecord::Migration
  def change
    create_table :register_skill_names do |t|
      t.references :skill
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :register_skill_names, :skill_id
  end
end
