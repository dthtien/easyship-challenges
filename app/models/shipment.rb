class Shipment < ApplicationRecord
  belongs_to :company
  has_many :shipment_items, dependent: :destroy

  def group_item_descriptions(order = :desc)
    shipment_items.group(:description)
                  .select(:description, 'count(id) as count')
                  .order("count(id) #{order}")
  end
end
