FactoryBot.define do
    factory :order do
        merchant { create(:merchant) }
        amount { 20 }
        disbursement_id { nil }
        status { 0 }
        commission_amount { merchant.commission_amount(amount) }
        trait :medium_amount do
            amount { 100 }
        end

        trait :premium_amount do
            amount { 330 }
        end

        trait :merchant_with_weekly do
            merchant { create(:merchant, :weekly_disbursement_freq) }
        end

        trait :completed do
            status { 1 }
        end
    end
end