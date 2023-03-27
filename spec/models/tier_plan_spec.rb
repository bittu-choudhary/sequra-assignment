require 'rails_helper'

RSpec.describe TierPlan, type: :model do
  describe 'associations' do
    it { should have_many(:merchant_tier_plans) }
  end
end
