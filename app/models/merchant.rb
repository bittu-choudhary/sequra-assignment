class Merchant < ApplicationRecord
  belongs_to :currency
  has_many :disbursements
  
  enum :live_on_weekday, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }, prefix: true
  enum :disbursement_frequency, { daily: 0, weekly: 1 }, suffix: true
end
