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

  describe "instance method calculate_monthly_fee_penalty - returns penalty between given dates" do
    let!(:merchant) { create(:merchant,:with_monthly_fee, live_on: Date.today - 10.month) }
    let!(:disbursement) { build(:disbursement, merchant: merchant, calculated_for: Date.today) }

    it "should return monthly fee penalty" do
      from = (Date.today - 1.month).beginning_of_month
      to = (Date.today - 1.month).end_of_month
      expect(disbursement.calculate_monthly_fee_penalty(from, to)).to eq(disbursement.merchant.minimum_monthly_fee)
    end
  end

  describe "instance method eligible_for_monthly_fee_penalty - check if disbursement should charge penalty" do
    let!(:merchant) { create(:merchant, live_on: Date.today - 1.month) }
    let!(:disbursement) { build(:disbursement, merchant: merchant, calculated_for: Date.today) }

    it "should return true" do
      expect(disbursement.eligible_for_monthly_fee_penalty?).to eq(true)
    end

  end

  describe "instance method calculate_prev_month_fee_penalty - return penalty for prev month" do
    let!(:merchant) { create(:merchant,:with_monthly_fee, live_on: Date.today - 1.month) }
    let!(:disbursement) { build(:disbursement, merchant: merchant) }

    it "should return prev month fee penalty" do
      expect(disbursement.calculate_prev_month_fee_penalty).to eq(merchant.minimum_monthly_fee)
    end
  end

  describe "instance method is_first_of_the_month? - returns true if disbursement is first of the month" do
    let!(:disbursement) { build(:disbursement, calculated_for: Date.today) }

    it "should return true" do
      expect(disbursement.is_first_of_the_month?).to eq(true)
    end

    it "should return false" do
      disbursement.save
      expect(disbursement.is_first_of_the_month?).to eq(false)
    end
  end 

  describe "instance method set_total_amount - returns final amount to be paid" do
    let!(:merchant) { create(:merchant) }
    let!(:orders) { create_list(:order, 3, merchant: merchant) }
    let!(:disbursement) { create(:disbursement, merchant: merchant, orders: orders) }

    it "should return correct total amount" do
      gross_order_value = orders.inject(0){|sum, order| sum += order.amount }.round(2)
      total_commission = orders.inject(0){|sum, order| sum += order.commission_amount }.round(2)
      
      expect(disbursement.total_amount).to eq(gross_order_value - total_commission)
    end
  end

end
