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
  
end
