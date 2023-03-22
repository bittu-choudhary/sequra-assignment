class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.datetime :live_on, null: false
      t.integer :live_on_weekday, null: false, default: 0
      t.integer :disbursement_frequency, null: false, default: 1
      t.float :minimum_monthly_fee, null: false, default: 0.0
      t.belongs_to :currency, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
