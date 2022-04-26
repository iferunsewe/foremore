class Delivery < ApplicationRecord
  belongs_to :pickup_address, class_name: 'Address'

  enum status: [:draft, :confirmed, :preparing, :ready, :delivering, :delivered]
  enum delivery_type: [:instant, :scheduled]
  enum weight_class: ["< 15", "15 - 300", "300 - 800"]
  enum length_class: ["< 1.4", "1.4 - 2.2", "2.2 - 3.4", "3.4 - 4.4"]

  validates_presence_of :pickup_address, :delivery_type, :weight_class, :length_class, :status

  before_validation :enums_to_i

  def enums_to_i
    self.status = self.status.to_i
    self.delivery_type = self.delivery_type.to_i
    self.weight_class = self.weight_class.to_i
    self.length_class = self.length_class.to_i
  end
end
