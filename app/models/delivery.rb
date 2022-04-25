class Delivery < ApplicationRecord
  enum status: [:draft, :confirmed, :preparing, :ready, :delivering, :delivered]
  enum delivery_type: [:instant, :scheduled]
end
