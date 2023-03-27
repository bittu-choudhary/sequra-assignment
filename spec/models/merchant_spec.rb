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

end
