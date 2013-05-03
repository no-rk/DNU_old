class CreateResultPetSkills < ActiveRecord::Migration
  def change
    create_table :result_pet_skills do |t|
      t.references :pet
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.integer :number
      t.references :skill
      t.references :source

      t.timestamps
    end
    add_index :result_pet_skills, :pet_id
    add_index :result_pet_skills, :user_id
    add_index :result_pet_skills, :day_id
    add_index :result_pet_skills, :way_id
    add_index :result_pet_skills, :skill_id
    add_index :result_pet_skills, :source_id
  end
end
