class Delivery < ApplicationRecord
  belongs_to :pickup_address, class_name: 'Address'

  enum status: [:draft, :pending, :confirmed, :preparing, :ready, :delivering, :delivered]
  enum delivery_type: [:instant, :scheduled]
  enum weight_class: ["< 15", "15 - 300", "300 - 800"]
  enum length_class: ["< 1.4", "1.4 - 2.2", "2.2 - 3.4", "3.4 - 4.4"]

  validates_presence_of :pickup_address, :delivery_type, :weight_class, :length_class, :status
end
