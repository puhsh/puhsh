class ChangePostDescriptionFromStringToText < ActiveRecord::Migration
  def change
    change_column :posts, :description, :text
  end
end
