class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders
  
  enum :status, { pending: 0, completed: 1 }, prefix: true
end
