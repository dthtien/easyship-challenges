class AddShipmentItemsCountToShipments < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :shipment_items_count, :integer, default: 0, null: false
  end
end
