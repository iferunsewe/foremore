json.extract! address, :id, :street, :city, :postcode, :company_name, :country, :created_at, :updated_at
json.url address_url(address, format: :json)
