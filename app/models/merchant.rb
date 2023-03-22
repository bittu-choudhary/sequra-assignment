class Merchant < ApplicationRecord
  belongs_to :currency
  has_many :disbursements
  has_many :orders
  has_many :merchant_tier_plans

  enum :live_on_weekday, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }, prefix: true
  enum :disbursement_frequency, { daily: 0, weekly: 1 }, suffix: true
end
