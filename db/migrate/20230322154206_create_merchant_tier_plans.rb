class CreateMerchantTierPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_tier_plans, id: :uuid do |t|
      t.belongs_to :merchant, null: false, foreign_key: true, type: :uuid
      t.belongs_to :tier_plan, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
