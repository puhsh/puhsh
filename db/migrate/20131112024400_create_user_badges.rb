class CreateUserBadges < ActiveRecord::Migration
  def change
    create_table :user_badges do |t|
      t.integer :user_id
      t.integer :badge_id
      t.timestamps
    end

    add_index :user_badges, :user_id
    add_index :user_badges, :badge_id
  end
end
