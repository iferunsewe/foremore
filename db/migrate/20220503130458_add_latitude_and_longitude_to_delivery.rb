class AddLatitudeAndLongitudeToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivery_latitude, :float
    add_column :deliveries, :delivery_longitude, :float
  end
end
