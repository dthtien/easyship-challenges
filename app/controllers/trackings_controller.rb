# frozen_string_literal: true

class TrackingsController < ApplicationController
  def show
    # TODO: Apply pooling to have better response time and save resources
    response = aftership_adapter.tracking(shipment.tracking_number)

    meta = response['meta']
    response_code = meta['code']
    if response_code == 200
      render json: parse_data(response['data'])
    else
      render json: meta, status: parse_error_code(response_code)
    end
  end

  private

  # ref: https://www.aftership.com/docs/aftership/quickstart/request-errors#http-status-code-summary
  def parse_error_code(response_code)
    case response_code
    when [4001, 4003]
      400
    when 4004
      404
    when (4005..4017)
      400
    else
      response_code
    end
  end

  def parse_data(data)
    last_checkpoint = data.dig('tracking', 'checkpoints').last
    {
      status: last_checkpoint['tag'],
      current_location: "#{last_checkpoint['location']}(#{last_checkpoint['slug']&.upcase})",
      last_checkpoint_message: last_checkpoint['message'],
      last_checkpoint_time: last_checkpoint['checkpoint_time']&.to_datetime&.strftime('%A, %d %B %Y at %I:%M %p')
    }
  end

  def aftership_adapter
    @aftership_adapter ||= AftershipAdapter.new
  end

  def shipment
    @shipment ||= Shipment.find_by(id: params[:shipment_id], company_id: params[:company_id])
  end
end
