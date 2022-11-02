# frozen_string_literal: true

class Shipment < ApplicationRecord
  RENDERING_FIELDS = %w[
    id company_id destination_country origin_country tracking_number slug created_at
  ].freeze
  belongs_to :company
  has_many :shipment_items, dependent: :destroy
  ORDER_DIRS = %w[desc asc].freeze

  scope :query_shipment_by_items_size, lambda { |size|
    left_joins(:shipment_items)
      .select(*RENDERING_FIELDS)
      .select('count(shipment_items.id) as items_count')
      .group(*RENDERING_FIELDS).having('items_count = ?', size)
  }

  def group_item_descriptions(order = nil)
    order = order.to_s.downcase
    order = ORDER_DIRS.include?(order) ? order : 'asc'
    if shipment_items.loaded?
      grouped_items = shipment_items.group_by(&:description).map do |description, items|
        OpenStruct.new({ description: description, count: items.count })
      end

      order == 'asc' ? grouped_items.sort_by(&:count) : grouped_items.sort_by(&:count).reverse!
    else
      shipment_items.group(:description)
                    .select(:description, 'count(id) as count')
                    .order("count(id) #{order}")
    end
  end
end
