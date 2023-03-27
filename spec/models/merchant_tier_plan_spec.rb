require 'rails_helper'

RSpec.describe MerchantTierPlan, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should belong_to(:tier_plan) }
  end

  describe 'validations' do
    it { should validate_presence_of(:merchant) }
    it { should validate_presence_of(:tier_plan) }
  end
end
