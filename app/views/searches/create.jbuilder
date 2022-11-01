json.shipments do
  json.array! @shipments do |shipment|
    json.call(shipment, :id, :company_id, :destination_country, :origin_country, :tracking_number, :slug)
    json.created_at shipment.created_at.strftime('%Y %B %d at %I:%M %p (%A)')

    json.items shipment.group_item_descriptions do |item|
      json.description item.description
      json.count item.count
    end
  end
end
