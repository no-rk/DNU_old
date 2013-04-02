class CreateResultNotices < ActiveRecord::Migration
  def change
    create_table :result_notices do |t|
      t.references :party
      t.string :kind
      t.references :enemy

      t.timestamps
    end
    add_index :result_notices, :party_id
    add_index :result_notices, :enemy_id
  end
end
