class MenuItem < ApplicationRecord
  belongs_to :menu_category
  has_one_attached :image

  validates :name,  presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(available: true) }
  scope :featured,  -> { where(featured: true) }
  scope :ordered,   -> { order(:display_order, :name) }
end
