class CreateDeliveryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_items do |t|
      t.integer :delivery_id
      t.integer :product_id
      t.integer :quantity
      t.integer :cart_id
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
