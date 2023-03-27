require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:merchant) }
    it { should validate_presence_of(:gross_order_value) }
    it { should validate_presence_of(:commission_amount) }
    it { should validate_presence_of(:monthly_fee_amount) }
    it { should validate_presence_of(:total_amount) }
    it { should validate_presence_of(:status) }
  end

end
