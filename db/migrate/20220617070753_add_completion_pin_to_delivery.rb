class AddCompletionPinToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :completion_pin, :integer
  end
end
