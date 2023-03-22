class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :merchant, null: false, foreign_key: true, type: :uuid
      t.belongs_to :disbursement, null: false, foreign_key: true, type: :uuid
      t.integer :status, null: false, default: 0
      t.boolean :is_part_of_disbursement, null: false, default: false
      t.datetime :disbursed_on
      t.datetime :completed_on
      t.float :amount, null: false, default: 0.0

      t.timestamps
    end
  end
end
