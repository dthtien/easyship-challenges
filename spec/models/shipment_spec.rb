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
      create_list(:shipment_item, 3, shipment: shipment, description: 'iPad')
      create_list(:shipment_item, 2, shipment: shipment, description: 'iPhone')
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

    shared_examples 'orders ascending' do
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

    context 'when order = asc' do
      let(:order) { :asc }

      it_behaves_like 'orders ascending'
    end

    context 'when order = nil' do
      let(:order) { nil }
      it_behaves_like 'orders ascending'
    end

    context 'when order is something, not desc nor asc' do
      let(:order) { 'ABC' }

      it_behaves_like 'orders ascending'
    end
  end

  describe '.query_shipment_by_items_size' do
    let!(:shipment1) { create(:shipment) }
    let!(:shipment2) { create(:shipment) }
    let!(:shipment3) { create(:shipment) }
    let!(:shipment) { create(:shipment) }
    let(:order) { :desc }
    let(:items_size) { 0 }
    let(:result) { described_class.query_shipment_by_items_size(items_size) }
    before do
      3.times do
        create(:shipment_item, shipment: shipment1, description: 'iPad')
      end
      2.times do
        create(:shipment_item, shipment: shipment2, description: 'iPhone')
      end
      create(:shipment_item, shipment: shipment3, description: 'Apple Watch')
    end

    context 'when query items size = 0' do
      let(:items_size) { 0 }
      it { expect(result).to eq [shipment] }
    end

    context 'when query items size = 1' do
      let(:items_size) { 1 }
      it { expect(result).to eq [shipment3] }
    end

    context 'when query items size = 2' do
      let(:items_size) { 2 }
      it { expect(result).to eq [shipment2] }
    end

    context 'when query items size = 3' do
      let(:items_size) { 3 }
      it { expect(result).to eq [shipment1] }
    end
  end
end
