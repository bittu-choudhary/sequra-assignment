# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'
logger = Logger.new(STDOUT)

logger.info "Seeding currency"

currencies = [
    {
        name: "euro",
        code: "EUR"
    }
]
currencies.each do |data|
    currency = Currency.new(data)
    unless currency.save
        logger.info "Currency not created: #{data}"
        logger.error currency.errors.full_messages
    end
end

logger.info "Currency seed complete"

logger.info "Seeding Tier plans"

plans = [
    {
        tier_limit: 50.0,
        tier_fee: 0.01
    },
    {
        tier_limit: 300.0,
        tier_fee: 0.0095
    },
    {
        tier_fee: 0.0085
    }
]

plans.each do |plan|
    tier = TierPlan.new(plan)
    unless tier.save
        logger.info "Tier plan not created: #{plan}"
        p plan.errors.full_messages
    end
end

logger.info "Tier plan seed complete"

logger.info "Seeding Merchants"

currency = Currency.find_by(code: "EUR")

CSV.read(Rails.root.join('lib', 'seeds', 'merchants.csv'), headers: true).each do |row|
    data = row.to_hash
    data["disbursement_frequency"].downcase!
    merchant = Merchant.new(data)
    merchant.currency = currency
    merchant.live_on_weekday = merchant.live_on.strftime('%w').to_i
    unless merchant.save
        logger.info "Merchant not created: #{row.to_hash}"
        p merchant.errors.full_messages
    end
end

logger.info "Merchant seed complete"

logger.info "Seeding Merchant tier plan"

Merchant.find_each.each do |merchant|
    TierPlan.find_each.each do |plan|
        MerchantTierPlan.create(merchant: merchant, tier_plan: plan)
    end
end

logger.info "Merchant tier plan seed complete"

logger.info "Seeding Orders"
group_by_merchant = {}
merchants = {}

logger.info "Reading orders data from import file"

orders_data = CSV.read(Rails.root.join('lib', 'seeds', 'orders.csv'), headers: true)

logger.info "Finished reading orders data from import file"

no_of_orders = orders_data.length
orders_imported = 0

logger.info "Starting processing orders"

orders_data.each do |row|
    data = row.to_hash
    
    merchants[data["merchant_reference"]] ||= Merchant.find_by(name: data["merchant_reference"])
    data["merchant_id"] = merchants[data["merchant_reference"]].id
    data["commission_amount"] = merchants[data["merchant_reference"]].commission_amount(data["amount"].to_f).round(2)

    group_by_merchant[data["merchant_reference"]] ||= []
    group_by_merchant[data["merchant_reference"]] << data.except("merchant_reference")

    orders_imported += 1 
    logger.info "#{orders_imported}/#{no_of_orders} orders imported" if orders_imported%1000 == 0
end
group_by_merchant.each do |name, data|
    Order.insert_all(data)
end

logger.info "Order seed complete"
