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
  scope :live_on_after, -> (day) { where("live_on > ?", day) }
  scope :live_on_or_before, -> (day) { where("live_on <= ?", day) }

  def monthly_fee_penalty(amount)
    if minimum_monthly_fee > amount
      return  (minimum_monthly_fee - amount)
    else
      0.0
    end
  end

  def commission_amount(amount)
    (amount*commission(amount))
  end

  def commission(amount)
    merchant_subscriptions = merchant_tier_plans.includes(:tier_plan)
    merchant_subscriptions.where.not(tier_plan: { tier_limit: nil }).order("tier_plan.tier_limit").each do |plan|
      return plan.tier_plan.tier_fee if amount < plan.tier_plan.tier_limit
    end

    max_limit_plan = merchant_subscriptions.find_by(tier_plan: { tier_limit: nil })
    return max_limit_plan.tier_plan.tier_fee
  end

end
