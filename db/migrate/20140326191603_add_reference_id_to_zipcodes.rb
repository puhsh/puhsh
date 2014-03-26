class AddReferenceIdToZipcodes < ActiveRecord::Migration
  def change
    add_column :zipcodes, :reference_id, :string, after: :location_type
  end
end
