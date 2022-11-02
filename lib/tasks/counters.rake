namespace :counters do
  task update_shipments: :environment do
    Shipment.find_each do |shipment|
      Shipment.reset_counters(shipment.id, :shipment_items)
    end
  end
end
