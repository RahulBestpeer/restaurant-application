class MenuCategory < ApplicationRecord
  TYPES = %w[food beverage paella tapas].freeze

  belongs_to :parent, class_name: "MenuCategory", optional: true
  has_many   :subcategories, class_name: "MenuCategory", foreign_key: :parent_id,
                             dependent: :destroy, inverse_of: :parent
  has_many :menu_items, dependent: :destroy

  validates :name,          presence: true
  validates :slug,          presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :category_type, presence: true, inclusion: { in: TYPES }

  scope :active,   -> { where(active: true) }
  scope :ordered,  -> { order(:display_order, :name) }
  scope :by_type,  ->(type) { where(category_type: type) }

  before_validation :generate_slug, on: :create

  def all_menu_items
    ids = [ id ] + subcategories.select(&:active?).map(&:id)
    MenuItem.where(menu_category_id: ids)
  end

  private

  def generate_slug
    self.slug ||= name.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
  end
end
