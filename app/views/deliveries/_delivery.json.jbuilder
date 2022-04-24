json.extract! delivery, :id, :status, :pickup_address_id, :delivery_address_id, :type, :weight, :length, :order_reference, :other_notes, :created_at, :updated_at
json.url delivery_url(delivery, format: :json)
