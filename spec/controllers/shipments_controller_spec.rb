require "rails_helper"

describe ShipmentsController, type: :controller do
  render_views

  describe 'GET show' do
    let(:company) { create(:company) }
    let!(:shipment) { create(:shipment, company_id: company.id) }
    let!(:shipment_item) { create(:shipment_item, shipment: shipment, description: 'name') }

    let(:json_response) { JSON.parse(response.body) }

    context 'when shipment found' do
      before do
        get :show, params: { company_id: shipment.company_id, id: shipment.id }, format: :json
      end

      it do
        expect(response).to have_http_status(:ok)
        expect(json_response.with_indifferent_access).to include(
          shipment: {
            company_id: shipment.company_id,
            company_name: company.name,
            origin_country: shipment.origin_country,
            destination_country: shipment.destination_country,
            tracking_number: shipment.tracking_number,
            slug: shipment.slug,
            created_at: shipment.created_at.strftime('%Y %B %d at %I:%M (%A)'),
            items:[
              {
                description: shipment_item.description,
                count: 1
              }
            ]
          }
        )
      end
    end

    context 'when shipment not found' do
      before do
        get :show, params: { company_id: 'not-found', id: 'not-found' }, format: :json
      end

      it do
        expect(response).to have_http_status(:not_found)
        expect(json_response['message']).to eq 'Record not found'
      end
    end
  end
end
