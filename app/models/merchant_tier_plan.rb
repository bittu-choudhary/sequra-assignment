class MerchantTierPlan < ApplicationRecord
  belongs_to :merchant
  belongs_to :tier_plan
end
