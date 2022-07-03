class AddStatusTimestampsToDeliveries < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivering_at, :datetime
    add_column :deliveries, :confirmed_at, :datetime
    add_column :deliveries, :ready_at, :datetime
  end
end
