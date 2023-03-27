class CreateTierPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :tier_plans, id: :uuid do |t|
      t.float :tier_limit
      t.float :tier_fee, default: 0.0

      t.timestamps
    end
  end
end
