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

  describe "scopes" do
    let!(:disb_calculated_for_between) { create(:disbursement, calculated_for: Date.today - 5.day) }

    it 'should return disbursements calculated for between specific dates' do
      expect(Disbursement.calculated_for_between(Date.today - 10.day, Date.today)).to include(disb_calculated_for_between)
    end
  end

end
