class CreateRegisterArtPullDowns < ActiveRecord::Migration
  def change
    create_table :register_art_pull_downs do |t|
      t.references :art
      t.string :pull_down

      t.timestamps
    end
    add_index :register_art_pull_downs, :art_id
  end
end
