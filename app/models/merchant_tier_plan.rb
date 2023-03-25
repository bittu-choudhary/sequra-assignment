class MerchantTierPlan < ApplicationRecord
  belongs_to :merchant
  belongs_to :tier_plan

  validates :merchant, presence: true
  validates :tier_plan, presence: true

end
