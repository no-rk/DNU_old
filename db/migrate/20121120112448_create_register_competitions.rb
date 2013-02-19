class CreateRegisterCompetitions < ActiveRecord::Migration
  def change
    create_table :register_competitions do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_competitions, :user_id
    add_index :register_competitions, :day_id
  end
end
