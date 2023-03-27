FactoryBot.define do
    factory :merchant_tier_plan do
        merchant { create(:merchant)}
        tier_plan { create(:tier_plan)}
    end
end