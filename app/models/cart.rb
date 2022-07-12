class Cart < ApplicationRecord
  belongs_to :user
  has_many :delivery_items, dependent: :destroy
  has_many :products, through: :delivery_items
  has_many :deliveries
  
end
