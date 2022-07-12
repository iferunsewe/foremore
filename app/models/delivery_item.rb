class DeliveryItem < ApplicationRecord
  belongs_to :delivery, optional: true
  belongs_to :product
  belongs_to :cart, optional: true
end
