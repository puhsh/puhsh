class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.integer :user_id
      t.integer :amount
      t.string :reason
      t.timestamps
    end
  end
end
