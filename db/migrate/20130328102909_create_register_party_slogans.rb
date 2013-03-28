class CreateRegisterPartySlogans < ActiveRecord::Migration
  def change
    create_table :register_party_slogans do |t|
      t.references :main
      t.string :kind
      t.string :slogan

      t.timestamps
    end
    add_index :register_party_slogans, :main_id
  end
end
