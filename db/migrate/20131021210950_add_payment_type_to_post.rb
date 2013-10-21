class AddPaymentTypeToPost < ActiveRecord::Migration
  def up
    add_column :posts, :payment_type, :string, after: :description
  end

  def down
    remove_column :posts, :payment_type
  end
end
