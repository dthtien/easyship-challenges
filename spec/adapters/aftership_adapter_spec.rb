require "rails_helper"

RSpec.describe AftershipAdapter, type: :adapter do
  let(:adapter) { described_class.new }
  describe '#tracking' do
    let(:id) { '56a9f8144f6acb330d76a483' }
    let(:tracking_url) do
      "https://api.aftership.com/v4/trackings/#{id}"
    end

    context 'when fetching success' do
      before do
        stub_request(:get, tracking_url)
          .to_return(body: success_response)
      end

      it do
        response = adapter.tracking(id)

        expect(response.dig('meta', 'code')).to be 200
        expect(response['data']).to include JSON.parse(success_response)['data']
      end
    end

    context 'when serve return not found status' do
      before do
        stub_request(:get, tracking_url)
          .to_return(body: failure_response)
      end

      it do
        response = adapter.tracking(id)

        expect(response.dig('meta', 'code')).to be 4004
        expect(response['data']).to be_nil
      end
    end

    context 'when fetching return internal server error' do
      before do
        stub_request(:get, tracking_url)
          .to_return(status: [500, 'Internal Server Error'])
      end

      it do
        response = adapter.tracking id

        meta = response['meta']
        expect(meta['code']).to be 500
        expect(meta['message']).to eq 'Aftership is not available'
        expect(response['data']).to be_nil
      end
    end

    context 'when server return bad gateway error' do
      before do
        stub_request(:get, tracking_url)
          .to_return(status: [502, 'Bad Gateway'])
      end

      it do
        response = adapter.tracking id

        meta = response['meta']
        expect(meta['code']).to be 502
        expect(meta['message']).to eq 'Aftership is not available'
        expect(response['data']).to be_nil
      end
    end
  end

  def file_fixture_path
    'spec/fixtures'
  end

  def success_response
    file_fixture('aftership/get_success_response.json').read
  end

  def failure_response
    file_fixture('aftership/get_failure_response.json').read
  end
end
