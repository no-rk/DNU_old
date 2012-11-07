class CreateGameDataStatuses < ActiveRecord::Migration
  def change
    create_table :game_data_statuses do |t|
      t.string :name
      t.text :caption

      t.timestamps
    end
  end
end
