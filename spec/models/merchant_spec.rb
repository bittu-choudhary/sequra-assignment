require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'associations' do
    it { should belong_to(:currency) }
    it { should have_many(:disbursements) }
    it { should have_many(:orders) }
    it { should have_many(:merchant_tier_plans) }
  end

  describe 'validations' do
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:live_on) }
    it { should validate_presence_of(:live_on_weekday) }
    it { should validate_presence_of(:disbursement_frequency) }
    it { should validate_presence_of(:minimum_monthly_fee) }
    it { should validate_presence_of(:email) }
  end

  describe 'scopes' do
    let!(:daily_disb_merchants) { create(:merchant) }
    let!(:weekly_disb_merchants) { create(:merchant, :weekly_disbursement_freq) }
    let!(:go_live_on_monday_merchants) { create(:merchant, live_on_weekday: "monday") }
    let!(:live_on_after_merchants) { create(:merchant, live_on: Date.today) }
    let!(:live_on_or_before_merchants) { create(:merchant, live_on: Date.today - 10.day) }

    it "should return merchant with daily disbursement freq" do
      expect(Merchant.with_daily_disbursement).to include(daily_disb_merchants)
    end

    it "should return merchant with weekly disbursement freq" do
      expect(Merchant.with_weekly_disbursement).to include(weekly_disb_merchants)
    end
    
    it "should return merchant that got live on monday" do
      expect(Merchant.got_live_on_weekday("monday")).to include(go_live_on_monday_merchants)
    end

    it "should return merchants that got live after specific date" do
      expect(Merchant.live_on_after(Date.today - 10.day)).to include(live_on_after_merchants)
    end

    it "should return merchants that got live on or before specific date" do
      expect(Merchant.live_on_or_before(Date.today)).to include(live_on_or_before_merchants)
    end
  end

  describe "instance method commission - should return applicable tier fee" do
    let!(:merchant) { create(:merchant) }

    it "should return 0.01" do
      expect(merchant.commission(20)).to eq(0.01)
    end

    it "should return 0.0095" do
      expect(merchant.commission(70)).to eq(0.0095)
    end

    it "should return 0.0085" do
      expect(merchant.commission(320)).to eq(0.0085)
    end
  end

  describe "instance method commission_amount - should return applicable net commission per order amount" do
    let!(:merchant) { create(:merchant) }

    it "should return 0.01*20" do
      expect(merchant.commission_amount(20)).to eq(0.01*20)
    end

    it "should return 0.0095*70" do
      expect(merchant.commission_amount(70)).to eq(0.0095*70)
    end

    it "should return 0.0085*320" do
      expect(merchant.commission_amount(320)).to eq(0.0085*320)
    end
  end

  describe "instance method monthly_fee_penalty - should return applicable monthly_fee_penalty based on sum of prev months commission amount" do
    let!(:merchant) { create(:merchant) }

    it "should return 0.0 as there is no minimum monthly fee merchant" do
      expect(merchant.monthly_fee_penalty(20)).to eq(10.0)
    end
    
    let!(:merchant) { create(:merchant, :with_monthly_fee) }
    it "should return 10" do
      expect(merchant.monthly_fee_penalty(20)).to eq(10)
    end

    it "should return 0.0 as commission is above minimum monthly fee" do
      expect(merchant.monthly_fee_penalty(320)).to eq(0.0)
    end
  end

end
