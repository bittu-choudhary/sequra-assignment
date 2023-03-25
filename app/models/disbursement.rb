class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  enum :status, { in_progress: 0, ready: 1, completed: 2 }, prefix: true
end
