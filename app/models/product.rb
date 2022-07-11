class Product < ApplicationRecord
  belongs_to :category
  has_many :delivery_items

  scope :search, -> (query) { where("name ILIKE ?", "%#{query}%") }

  has_one_attached :image do |attachable|
    attachable.variant :small, resize_to_fit: [200, 200]
  end
end
