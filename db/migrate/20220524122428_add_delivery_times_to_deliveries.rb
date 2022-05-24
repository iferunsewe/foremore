class AddDeliveryTimesToDeliveries < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :prep_time, :integer
    add_column :deliveries, :travel_time, :integer
  end
end
