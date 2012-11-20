class CreateRegisterCompetitions < ActiveRecord::Migration
  def change
    create_table :register_competitions do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_competitions, :user_id
  end
end
