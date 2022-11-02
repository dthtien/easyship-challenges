# frozen_string_literal: true

class SearchesController < ApplicationController
  def create
    # TODO: resolve N+1 query
    @shipments = Shipment.includes(:shipment_items).where(company_id: params[:company_id])
                         .query_shipment_by_items_size(params[:shipment_items_size].to_i)

    render :create
  end
end
