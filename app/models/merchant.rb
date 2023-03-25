class Merchant < ApplicationRecord
  belongs_to :currency
  has_many :disbursements
  has_many :orders
  has_many :merchant_tier_plans

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :live_on, presence: true
  validates :live_on_weekday, presence: true
  validates :disbursement_frequency, presence: true
  validates :minimum_monthly_fee, presence: true
  validates :currency, presence: true

  enum :live_on_weekday, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }, prefix: true
  enum :disbursement_frequency, { daily: 0, weekly: 1 }, suffix: true

  scope :with_daily_disbursement, -> { where(disbursement_frequency: "daily") }
  scope :with_weekly_disbursement, -> { where(disbursement_frequency: "weekly") }
  scope :got_live_on_weekday, -> (weekday) { where(live_on_weekday: weekday) }

end
