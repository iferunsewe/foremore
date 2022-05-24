class RemoveExpectedTimeFromDeliveries < ActiveRecord::Migration[7.0]
  def change
    remove_column :deliveries, :expected_time
  end
end
