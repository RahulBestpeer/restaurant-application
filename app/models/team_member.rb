class TeamMember < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
  validates :role, presence: true

  scope :active,   -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered,  -> { order(:position, :name) }
end
