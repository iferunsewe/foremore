class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.integer :status, default: 0
      t.integer :pickup_address_id
      t.string :delivery_address
      t.integer :delivery_type
      t.integer :weight_class
      t.integer :length_class
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
