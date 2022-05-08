class AddDeliveredAtToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivered_at, :datetime
  end
end
