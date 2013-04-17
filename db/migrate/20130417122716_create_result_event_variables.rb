class CreateResultEventVariables < ActiveRecord::Migration
  def change
    create_table :result_event_variables do |t|
      t.references :event
      t.string :kind
      t.string :name
      t.text :value

      t.timestamps
    end
    add_index :result_event_variables, :event_id
  end
end
