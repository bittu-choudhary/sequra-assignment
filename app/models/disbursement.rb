class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :merchant, presence: true
  validates :gross_order_value, presence: true
  validates :commission_amount, presence: true
  validates :monthly_fee_amount, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true

  enum :status, { in_progress: 0, ready: 1, completed: 2 }, prefix: true
  scope :calculated_for_between, -> (from, to) { where("calculated_for >= ? AND calculated_for <= ?", from, to ) }

  before_save :set_total_amount

  class << self

    def calculate(merchants = Merchant.all, day = Date.today)
      merchants.each do |merchant|
        calculate_for_merchant(merchant, day)
      end
    end

    def calculate_for_merchant(merchant = nil, day = Date.today)
      return unless merchant.is_a?(Merchant)
      disbursement = Disbursement.where(merchant: merchant, calculated_for: day, status: [0, 1]).first_or_initialize
      disbursement.update(status: 0) if disbursement.status_ready?
      from = merchant.daily_disbursement_frequency? ? day.beginning_of_day : (day - 7.day).beginning_of_day
      to = day.end_of_day
      qualified_orders = Order.pending_disbursement_calculation.received_by(merchant).created_between(from, to)

      unless qualified_orders.empty?
        disbursement.has_orders_from = qualified_orders.first.created_at
        disbursement.has_orders_to = qualified_orders.last.created_at
        disbursement.gross_order_value += qualified_orders.sum(:amount).round(2)
        disbursement.commission_amount += qualified_orders.sum(:commission_amount).round(2)
      end

      if disbursement.save
        disbursement.update(status: 1) if qualified_orders.update_all(disbursement_id: disbursement.id)
      end
    end
  end

  def eligible_for_monthly_fee_penalty?
    return false unless is_first_of_the_month?
    return false if merchant.live_on.beginning_of_month >= calculated_for.beginning_of_month
    true
  end

  def calculate_prev_month_fee_penalty
    from = calculated_for.beginning_of_month - 1.month
    to = calculated_for.end_of_month - 1.month
    calculate_monthly_fee_penalty(from, to)
  end

  def calculate_monthly_fee_penalty(beginning_of_month, end_of_month)
    disbursements = merchant.disbursements.calculated_for_between(beginning_of_month, end_of_month)
    return merchant.minimum_monthly_fee if disbursements.empty?
    merchant.monthly_fee_(disbursements.sum(:commission_amount))
  end

  def is_first_of_the_month?
    merchant.disbursements.calculated_for_between(calculated_for.beginning_of_month, calculated_for.end_of_month).empty?
  end

  def set_total_amount
    self.total_amount = self.gross_order_value - self.commission_amount
  end
end
