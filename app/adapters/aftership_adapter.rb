# frozen_string_literal: true

class AftershipAdapter < ApplicationAdapter
  AS_ENDPOINT = 'https://api.aftership.com/v4'

  def tracking(id)
    request = build_tracking_request(id)
    response = http_client.request(request)
    if response.code.to_i >= 500
      {
        meta: {
          code: response.code.to_i,
          message: 'Aftership is not available'
        }
      }.with_indifferent_access
    else
      parse_body response
    end
  end

  private

  def url
    @url ||= URI(AS_ENDPOINT)
  end

  def build_tracking_request(id)
    tracking_url = URI("#{AS_ENDPOINT}/trackings/#{id}")
    request = Net::HTTP::Get.new(tracking_url)
    request['Content-Type'] = 'application/json'
    request['as-api-key'] = ENV['AS_API_KEY']
    request
  end
end
