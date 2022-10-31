require "rails_helper"

describe TrackingsController, type: :controller do
  describe 'GET show' do
    let(:company) { create(:company) }
    let!(:shipment) { create(:shipment, company_id: company.id, tracking_number: '5b7658cec7c33c0e007de3c5') }
    let!(:shipment_item) { create(:shipment_item, shipment: shipment, description: 'name') }

    let(:json_response) { JSON.parse(response.body) }
    let(:data_response) { {} }
    let(:adapter_double) { instance_double(AftershipAdapter, tracking: data_response) }

    before do
      allow(AftershipAdapter).to receive(:new).and_return(adapter_double)
    end

    context 'when adapter return success response' do
      let(:data_response) { success_response }

      before do
        get :show, params: { company_id: shipment.company_id, shipment_id: shipment.id }, format: :json
      end

      it do
        expect(adapter_double).to have_received(:tracking).with(shipment.tracking_number)
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq success_response['data']
      end
    end

    context 'when adapter return failure response' do
      let(:data_response) { failure_response }

      before do
        get :show, params: { company_id: shipment.company_id, shipment_id: shipment.id }, format: :json
      end

      it do
        expect(adapter_double).to have_received(:tracking).with(shipment.tracking_number)
        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq failure_response['meta']
      end
    end
  end

  def success_response
    JSON.parse File.open("#{Rails.root}/spec/fixtures/aftership/get_success_response.json", 'rb').read
  end

  def failure_response
    JSON.parse File.open("#{Rails.root}/spec/fixtures/aftership/get_failure_response.json", 'rb').read
  end
end
