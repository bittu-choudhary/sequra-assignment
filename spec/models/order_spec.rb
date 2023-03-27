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
end
