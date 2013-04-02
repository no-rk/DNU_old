class CreateResultSkills < ActiveRecord::Migration
  def change
    create_table :result_skills do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :skill
      t.string :name
      t.text :caption
      t.integer :exp
      t.boolean :forget

      t.timestamps
    end
    add_index :result_skills, :character_id
    add_index :result_skills, :day_id
    add_index :result_skills, :skill_id
  end
end
