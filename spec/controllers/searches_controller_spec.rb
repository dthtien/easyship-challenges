require 'rails_helper'

describe SearchesController, type: :controller do
  render_views

  describe 'POST create' do
    let(:company) { create(:company) }
    let!(:shipment) { create(:shipment, company_id: company.id) }
    let!(:shipment_item) { create(:shipment_item, shipment: shipment, description: 'name') }

    let(:json_response) { JSON.parse(response.body) }

    before do
      allow(Shipment).to receive(:query_shipment_by_items_size).and_call_original
      post :create, params: { company_id: shipment.company_id, shipment_items_size: 1 }, format: :json
    end

    it do
      expect(Shipment).to have_received(:query_shipment_by_items_size).with(1)
      expect(response).to have_http_status(:ok)
      expect(json_response.with_indifferent_access).to include(
        shipments: [{
          id: shipment.id,
          company_id: shipment.company_id,
          origin_country: shipment.origin_country,
          destination_country: shipment.destination_country,
          tracking_number: shipment.tracking_number,
          slug: shipment.slug,
          created_at: shipment.created_at.strftime('%Y %B %d at %I:%M (%A)'),
          items: [
            {
              description: shipment_item.description,
              count: 1
            }
          ]
        }]
      )
    end
  end
end
