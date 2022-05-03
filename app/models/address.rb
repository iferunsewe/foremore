class Address < ApplicationRecord
  has_many :deliveries

  geocoded_by :one_line
  after_validation :geocode
  
  def one_line
    return [street, city, postcode].join(', ') if company_name.nil?
    [company_name, street, city, postcode].join(', ')
  end
end
