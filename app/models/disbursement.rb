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
    
  end

  def set_total_amount
    self.total_amount = self.gross_order_value - self.commission_amount
  end
end
