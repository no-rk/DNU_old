class CreateGameDataStatuses < ActiveRecord::Migration
  def change
    create_table :game_data_statuses do |t|
      t.string :name
      t.text :caption
      t.text :definition
      t.text :tree

      t.timestamps
    end
  end
end
