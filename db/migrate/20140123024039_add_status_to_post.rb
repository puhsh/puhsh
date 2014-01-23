class AddStatusToPost < ActiveRecord::Migration
  def change
    add_column :posts, :status, :string, after: :payment_type
  end
end
