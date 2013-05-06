class CreateResultNotices < ActiveRecord::Migration
  def change
    create_table :result_notices do |t|
      t.references :battle_type
      t.references :party
      t.references :enemy

      t.timestamps
    end
    add_index :result_notices, :battle_type_id
    add_index :result_notices, :party_id
    add_index :result_notices, :enemy_id
  end
end
