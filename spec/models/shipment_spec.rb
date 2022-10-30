require "rails_helper"

RSpec.describe Shipment, type: :model do
  describe 'associations' do
    specify do
      t = described_class.reflect_on_association(:company)
      expect(t.macro).to eq(:belongs_to)

      t = described_class.reflect_on_association(:shipment_items)
      expect(t.macro).to eq(:has_many)
      expect(t.options).to include(dependent: :destroy)
    end
  end

  describe '#group_item_descriptions' do
    let(:shipment) { create(:shipment) }
    let(:order) { :desc }
    let(:result) { shipment.group_item_descriptions(order) }
    before do
      3.times do
        create(:shipment_item, shipment: shipment, description: "iPad")
      end
      2.times do
        create(:shipment_item, shipment: shipment, description: 'iPhone')
      end
      create(:shipment_item, shipment: shipment, description: 'Apple Watch')
    end

    context 'when order = desc' do
      let(:order) { :desc }
      specify do
        expect(result.as_json(except: :id)).to eq [
          {
            'description' => 'iPad',
            'count' => 3,
          },
          {
            'description' => 'iPhone',
            'count' => 2,
          },
          {
            'description' => 'Apple Watch',
            'count' => 1,
          },
        ]
      end
    end

    context 'when order = asc' do
      let(:order) { :asc }
      specify do
        expect(result.as_json(except: :id)).to eq [
          {
            'description' => 'Apple Watch',
            'count' => 1,
          },
          {
            'description' => 'iPhone',
            'count' => 2,
          },
          {
            'description' => 'iPad',
            'count' => 3,
          },
        ]
      end
    end
  end
end
