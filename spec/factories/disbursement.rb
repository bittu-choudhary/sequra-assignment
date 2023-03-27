FactoryBot.define do
    factory :disbursement do
        merchant { create(:merchant) }
        orders { create_list(:order, 3, merchant: merchant)}
        calculated_for { Date.today }
        after(:create) do |disbursement|
            disbursement.gross_order_value = disbursement.orders.sum(:amount)
            disbursement.commission_amount = disbursement.orders.sum(:commission_amount)
            disbursement.total_amount = disbursement.gross_order_value - disbursement.commission_amount
            status = 2
            disbursement.save
        end
    
    end
end