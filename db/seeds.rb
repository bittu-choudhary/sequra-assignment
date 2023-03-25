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