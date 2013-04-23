class CreateResultPartyMembers < ActiveRecord::Migration
  def change
    create_table :result_party_members do |t|
      t.references :party
      t.references :character, :polymorphic => true
      t.integer :correction

      t.timestamps
    end
    add_index :result_party_members, :party_id
    add_index :result_party_members, :character_id
  end
end
