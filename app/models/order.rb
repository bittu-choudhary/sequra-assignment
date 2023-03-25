class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :merchant, presence: true
  validates :disbursement, presence: true
  validates :status, presence: true
  validates :amount, presence: true

  enum :status, { pending: 0, completed: 1 }, prefix: true

  scope :completed, -> { where(status: 1) }
  scope :pending, -> { where(status: 0) }

  after_create :calculate_commission

  def calculate_commission
    self.commission_amount = merchant.commission_amount(amount).round(2)
  end

end
