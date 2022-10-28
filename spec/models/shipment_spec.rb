require "rails_helper"

RSpec.describe Shipment, type: :model do
  describe 'associations' do
    specify do
      t = described_class.reflect_on_association(:company)
      expect(t.macro).to eq(:belongs_to)

      t = described_class.reflect_on_association(:shipment_items)
      expect(t.macro).to eq(:has_many)
    end
  end
end
