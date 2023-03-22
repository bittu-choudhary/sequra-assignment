class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement

  enum :status, { pending: 0, completed: 1 }, prefix: true
end
