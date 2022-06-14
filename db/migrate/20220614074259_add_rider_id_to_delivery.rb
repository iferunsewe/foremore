class AddRiderIdToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :rider_id, :integer
  end
end
