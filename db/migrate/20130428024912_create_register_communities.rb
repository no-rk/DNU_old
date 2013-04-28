class CreateRegisterCommunities < ActiveRecord::Migration
  def change
    create_table :register_communities do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_communities, :user_id
    add_index :register_communities, :day_id
  end
end
