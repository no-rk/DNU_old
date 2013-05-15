class CreateGameDataEffectDescriptions < ActiveRecord::Migration
  def change
    create_table :game_data_effect_descriptions do |t|
      t.string :name
      t.text :caption

      t.timestamps
    end
  end
end
