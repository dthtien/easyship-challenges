# frozen_string_literal: true

class TrackingsController < ApplicationController
  def show
    # TODO: Apply pooling to have better response time and save resources
    response = aftership_adapter.tracking(shipment.tracking_number)

    meta = response['meta']
    if meta['code'] == 200
      render json: response['data']
    else
      render json: meta, status: meta['code']
    end
  end

  private

  def aftership_adapter
    @aftership_adapter ||= AftershipAdapter.new
  end

  def shipment
    @shipment ||= Shipment.find_by(id: params[:shipment_id], company_id: params[:company_id])
  end
end
