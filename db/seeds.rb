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
