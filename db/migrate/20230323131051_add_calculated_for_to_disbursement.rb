class AddCalculatedForToDisbursement < ActiveRecord::Migration[7.0]
  def change
    add_column :disbursements, :calculated_for, :datetime
  end
end
