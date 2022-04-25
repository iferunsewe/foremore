class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.integer :status
      t.integer :pickup_address_id
      t.integer :delivery_address
      t.integer :delivery_type
      t.integer :weight
      t.integer :length
      t.string :order_reference
      t.text :other_notes
      t.string :address_notes
      t.string :recipient_name
      t.string :recipient_email
      t.string :recipient_phone
      t.datetime :scheduled_date
      t.text :description

      t.timestamps
    end
  end
end
