# frozen_string_literal: true

class Shipment < ApplicationRecord
  belongs_to :company
  has_many :shipment_items, dependent: :destroy
  ORDER_DIRS = %w[desc asc].freeze

  def group_item_descriptions(order = nil)
    order = ORDER_DIRS.include?(order.to_s.downcase) ? order : 'asc'
    shipment_items.group(:description)
                  .select(:description, 'count(id) as count')
                  .order("count(id) #{order}")
  end
end
