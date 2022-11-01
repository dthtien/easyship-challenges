json.shipment do
  json.company_id           @shipment.company_id
  json.company_name         @shipment.company.name
  json.origin_country       @shipment.origin_country
  json.destination_country  @shipment.destination_country
  json.tracking_number      @shipment.tracking_number
  json.slug                 @shipment.slug
  json.created_at           @shipment.created_at.strftime('%Y %B %d at %I:%M (%A)')

  json.items @items do |item|
    json.description        item.description
    json.count             item.count
  end
end
