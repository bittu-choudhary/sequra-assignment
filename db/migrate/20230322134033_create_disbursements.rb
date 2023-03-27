class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.belongs_to :merchant, null: false, foreign_key: true, type: :uuid
      t.datetime :has_orders_from
      t.datetime :has_orders_to
      t.float :gross_order_value, null: false, default: 0.0
      t.float :commission_amount, null: false, default: 0.0
      t.float :monthly_fee_amount, null: false, default: 0.0
      t.float :total_amount, null: false, default: 0.0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
