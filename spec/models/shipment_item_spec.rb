require 'rails_helper'

RSpec.describe ShipmentItem, type: :model do
  describe 'associations' do
    specify do
      t = described_class.reflect_on_association(:shipment)
      expect(t.macro).to eq(:belongs_to)
      expect(t.options).to include(counter_cache: true)
    end
  end
end
