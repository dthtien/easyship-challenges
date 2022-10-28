class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def show
    @shipment = Shipment.find_by!(id: params[:id], company_id: params[:company_id])
    @items = @shipment.group_item_descriptions(params[:items_order])
  end
end
