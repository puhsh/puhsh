class AddFullStateNameToCities < ActiveRecord::Migration
  def change
    add_column :cities, :full_state_name, :string
  end
end
