# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

puts "Seeding currency"

currencies = [
    {
        name: "euro",
        code: "EUR"
    }
]
currencies.each do |data|
    currency = Currency.new(data)
    unless currency.save
        puts "Currency not created: #{data}"
        p currency.errors.full_messages
    end
end

puts "Currency seed complete"

puts "Seeding Tier plans"

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
        puts "Tier plan not created: #{plan}"
        p plan.errors.full_messages
    end
end

puts "Tier plan seed complete"

puts "Seeding Merchants"

currency = Currency.find_by(code: "EUR")

CSV.read(Rails.root.join('lib', 'seeds', 'merchants.csv'), headers: true).each do |row|
    data = row.to_hash
    data["disbursement_frequency"].downcase!
    merchant = Merchant.new(data)
    merchant.currency = currency
    merchant.live_on_weekday = merchant.live_on.strftime('%w').to_i
    unless merchant.save
        puts "Merchant not created: #{row.to_hash}"
        p merchant.errors.full_messages
    end
end

puts "Merchant seed complete"

puts "Seeding Merchant tier plan"

Merchant.find_each.each do |merchant|
    TierPlan.find_each.each do |plan|
        MerchantTierPlan.create(merchant: merchant, tier_plan: plan)
    end
end

puts "Merchant tier plan seed complete"

puts "Seeding Orders"
group_by_merchant = {}
merchants = {}

puts "Reading orders data from import file"

orders_data = CSV.read(Rails.root.join('lib', 'seeds', 'orders.csv'), headers: true)

puts "Finished reading orders data from import file"

no_of_orders = orders_data.length
orders_imported = 0

puts "Starting processing orders"

orders_data.each do |row|
    data = row.to_hash
    
    merchants[data["merchant_reference"]] ||= Merchant.find_by(name: data["merchant_reference"])
    data["merchant_id"] = merchants[data["merchant_reference"]].id
    data["commission_amount"] = merchants[data["merchant_reference"]].commission_amount(data["amount"].to_f).round(2)

    group_by_merchant[data["merchant_reference"]] ||= []
    group_by_merchant[data["merchant_reference"]] << data.except("merchant_reference")

    orders_imported += 1 
    puts "#{orders_imported}/#{no_of_orders} imported" if orders_imported%1000 == 0
end
group_by_merchant.each do |name, data|
    Order.insert_all(data)
end

puts "Order seed complete"
