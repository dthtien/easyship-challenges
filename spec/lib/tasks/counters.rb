require "rails_helper"
Rails.application.load_tasks

describe 'Counters' do
  describe 'update_shipments' do
    let!(:shipment) { create(:shipment) }
    let!(:shipment2) { create(:shipment) }
    let!(:shipment3) { create(:shipment) }

    before do
      create_list(:shipment_item, 3, shipment: shipment, description: 'iPad')
      create_list(:shipment_item, 2, shipment: shipment2, description: 'iPhone')
      create(:shipment_item, shipment: shipment3, description: 'Apple Watch')

      Shipment.update_all(shipment_items_count: 0)
      Rake::Task['counters:update_shipments'].invoke
      shipment.reload
      shipment2.reload
      shipment3.reload
    end

    it do
      expect(shipment.shipment_items_count).to eq 3
      expect(shipment2.shipment_items_count).to eq 2
      expect(shipment3.shipment_items_count).to eq 1
    end
  end
end
