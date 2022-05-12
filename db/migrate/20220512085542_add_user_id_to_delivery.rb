class AddUserIdToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_reference :deliveries, :user, foreign_key: true
  end
end
