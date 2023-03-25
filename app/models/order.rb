class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :merchant, presence: true
  validates :disbursement, presence: true
  validates :status, presence: true
  validates :amount, presence: true

  enum :status, { pending: 0, completed: 1 }, prefix: true

end
