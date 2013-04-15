class CreateRegisterSkillConfs < ActiveRecord::Migration
  def change
    create_table :register_skill_confs do |t|
      t.references :skill
      t.references :game_data_skill
      t.string :kind

      t.timestamps
    end
    add_index :register_skill_confs, :skill_id
    add_index :register_skill_confs, :game_data_skill_id
  end
end
