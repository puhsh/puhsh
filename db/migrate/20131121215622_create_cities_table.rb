class CreateCitiesTable < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.tables.include?(:cities)
      drop_table :cities
    end
    create_table :cities do |t|
      t.string :state
      t.string :city
    end
  end
end
