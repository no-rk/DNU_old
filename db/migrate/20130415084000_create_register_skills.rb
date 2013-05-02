class CreateRegisterSkills < ActiveRecord::Migration
  def change
    create_table :register_skills do |t|
      t.references :user
      t.references :day
      t.references :skill

      t.timestamps
    end
    add_index :register_skills, :user_id
    add_index :register_skills, :day_id
    add_index :register_skills, :skill_id
  end
end
