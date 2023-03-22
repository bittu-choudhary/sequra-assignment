class Disbursement < ApplicationRecord
  belongs_to :merchant
  enum :status, { pending: 0, completed: 1 }, prefix: true
end
