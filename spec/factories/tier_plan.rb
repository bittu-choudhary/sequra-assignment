FactoryBot.define do
    factory :tier_plan do
        tier_limit { 50.0 }
        tier_fee { 0.01 }
    
        trait :medium do
            tier_limit { 300.0 }
            tier_fee { 0.0095 }
        end
    
        trait :premium do
            tier_limit { nil }
            tier_fee { 0.0085 }
        end
    end
end