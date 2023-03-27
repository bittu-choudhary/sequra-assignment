FactoryBot.define do
    factory :merchant do
        name { Faker::Company.name }
        email { Faker::Internet.email }
        live_on {Date.today - 10.month}
        live_on_weekday { (Date.today - 10.month).strftime('%w').to_i }
        currency { Currency.find_by_code("EUR") || create(:currency) }
        minimum_monthly_fee { 0.0 }
        disbursement_frequency { 0 }

        trait :weekly_disbursement_freq do
            disbursement_frequency {1 }
        end

        trait :with_monthly_fee do
            minimum_monthly_fee { 30 }
        end
        
        after(:create) do |merchant|
            create(:merchant_tier_plan, merchant: merchant, tier_plan: create(:tier_plan))
            create(:merchant_tier_plan, merchant: merchant, tier_plan: create(:tier_plan, :medium))
            create(:merchant_tier_plan, merchant: merchant, tier_plan: create(:tier_plan, :premium))
        end
    end
end