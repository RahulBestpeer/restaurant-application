class GalleryItem < ApplicationRecord
  MEDIA_TYPES = %w[photo video].freeze
  CATEGORIES  = %w[interior atmosphere food paella tapas events].freeze

  has_one_attached :image

  validates :title,      presence: true
  validates :media_type, inclusion: { in: MEDIA_TYPES }
  validates :category,   inclusion: { in: CATEGORIES }
  validates :video_url, presence: { message: "is required for video items" }, if: :video?

  scope :featured, -> { where(featured: true) }
  scope :ordered,  -> { order(:position, :created_at) }
  scope :by_category, ->(cat) { where(category: cat) }
  scope :by_type,     ->(type) { where(media_type: type) }

  def photo?
    media_type == "photo"
  end

  def video?
    media_type == "video"
  end
end
