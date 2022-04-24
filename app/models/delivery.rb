class Delivery < ApplicationRecord
  enum status: [:draft, :confirmed, :preparing, :ready, :delivering, :delivered]
  enum type: [:instant, :scheduled]
end
