class ShipmentItem < ApplicationRecord
  belongs_to :shipment, counter_cache: true
end
