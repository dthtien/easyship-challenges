require "rails_helper"

RSpec.describe AftershipAdapter, type: :adapter do
  let(:adapter) { described_class.new }
  describe '#tracking' do
    let(:id) { '56a9f8144f6acb330d76a483' }
    context 'when fetching success' do
      before do
        stub_request(:get, "https://api.aftership.com/v4/trackings/#{id}")
          .to_return(body: success_response)
      end

      it do
        response = adapter.tracking(id)

        expect(response.dig('meta', 'code')).to be 200
        expect(response['data']).to include JSON.parse(success_response)['data']
      end
    end

    context 'when fetching failed' do
      before do
        stub_request(:get, "https://api.aftership.com/v4/trackings/#{id}")
          .to_return(body: failure_response)
      end

      it do
        response = adapter.tracking(id)

        expect(response.dig('meta', 'code')).to be 404
        expect(response['data']).to be_nil
      end
    end
  end

  def success_response
    File.open("#{Rails.root}/spec/fixtures/aftership/get_success_response.json", 'rb').read
  end

  def failure_response
    File.open("#{Rails.root}/spec/fixtures/aftership/get_failure_response.json", 'rb').read
  end
end

