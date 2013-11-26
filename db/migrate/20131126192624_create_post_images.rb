class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.integer :post_id
      t.timestamps
    end

    add_index :post_images, :post_id
  end
end
