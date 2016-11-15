require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  describe '#normalize' do
    it 'normalizes a phone number' do
      expect(PhoneNumber.normalize '555-555-5555').to eq('5555555555')
    end

    it 'normalizes a phone number with country code' do
      expect(PhoneNumber.normalize '+1 555-555-5555').to eq('5555555555')
    end

    it 'returns nil for an invalid phone number' do
      expect(PhoneNumber.normalize '555-555-555').to be_nil
    end
  end
end
