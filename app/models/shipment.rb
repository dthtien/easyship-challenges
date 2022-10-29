# frozen_string_literal: true

class Shipment < ApplicationRecord
  RENDERING_FIELDS = %w[
    id company_id destination_country origin_country tracking_number slug created_at
  ].freeze
  belongs_to :company
  has_many :shipment_items

  scope :query_shipment_by_items_size, lambda { |size|
    left_joins(:shipment_items)
      .select(*RENDERING_FIELDS)
      .select('count(shipment_items.id) as items_count')
      .group(*RENDERING_FIELDS).having('items_count = ?', size || 1)
  }

  def group_item_descriptions(order = :desc)
    shipment_items.group(:description)
                  .select(:description, 'count(id) as count')
                  .order("count(id) #{order}")
  end
end
