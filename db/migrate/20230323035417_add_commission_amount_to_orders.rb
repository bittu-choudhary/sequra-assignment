class AddCommissionAmountToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :commission_amount, :float
  end
end
