class CreateCitiesTable < ActiveRecord::Migration
  def change
    drop_table :cities
    create_table :cities do |t|
      t.string :state
      t.string :city
    end
  end
end
