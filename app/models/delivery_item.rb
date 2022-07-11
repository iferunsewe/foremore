class DeliveryItem < ApplicationRecord
  belongs_to :delivery
  belongs_to :product
end
