class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :gender
      t.string :facebook_email
      t.string :contact_email
      t.timestamps
    end
  end
end
