require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:merchant) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:amount) }
  end

  describe 'scopes' do

    let!(:complete_order) { create(:order, :completed) }
    let!(:pending_order) { create(:order) }
    let!(:undisbursed_order) { create(:order) }
    let!(:merchant) { create(:merchant) }
    let!(:received_by) { create(:order, merchant: merchant) }
    let!(:created_between) { create(:order, created_at: Date.today - 5.day) }

    it 'should return completed orders' do
      expect(Order.completed).to include(complete_order)
    end

    it 'should return pending orders' do
      expect(Order.pending).to include(pending_order)
    end

    it 'should return undisbursed orders' do
      expect(Order.pending_disbursement_calculation).to include(undisbursed_order)
    end

    it 'should return orders own by' do
      expect(Order.received_by(merchant)).to include(received_by)
    end

    it 'should return created between specific dates' do
      expect(Order.created_between(Date.today - 10.day, Date.today)).to include(created_between)
    end

  end

  describe "calculate commission" do
    let!(:merchant) { create(:merchant) }
    let!(:order) { create(:order, amount: 20) }
    commission = 20*0.01
    it 'should calculate correct commission for basic tier' do
      expect(order.calculate_commission).to eq(commission)
    end

    let!(:order) { create(:order, amount: 80) }
    commission = 80*0.0095
    it 'should calculate correct commission for medium tier' do
      expect(order.calculate_commission).to eq(commission)
    end

    let!(:order) { create(:order, amount: 320) }
    commission = 320*0.0085
    it 'should calculate correct commission for premium tier' do
      expect(order.calculate_commission).to eq(commission)
    end
  end
end
