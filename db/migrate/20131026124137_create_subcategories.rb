class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.integer :category_id
      t.string :name
      t.string :status, default: :active
      t.timestamps
    end
  end
end
