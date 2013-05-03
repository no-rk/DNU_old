class CreateGameDataGuardians < ActiveRecord::Migration
  def change
    create_table :game_data_guardians do |t|
      t.references :train
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :game_data_guardians, :train_id
  end
end
