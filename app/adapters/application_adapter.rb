# frozen_string_literal: true
require 'net/http'

class ApplicationAdapter
  private

  def url
    raise 'Undefined method'
  end

  def parse_body(request)
    JSON.parse(request.body)
  end

  def http_client
    @http_client ||=
      begin
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end
  end
end
