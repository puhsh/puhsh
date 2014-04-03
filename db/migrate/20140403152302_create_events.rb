class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :user_ip_address
      t.integer :resource_id
      t.string :resource_type
      t.string :controller_name
      t.string :controller_action
      t.timestamps
    end

    add_index :events, [:user_id, :resource_id, :resource_type, :controller_name, :controller_action], unique: true, name: "index_unique_event_user_resource"
  end
end
