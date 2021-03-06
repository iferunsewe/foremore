class Address < ApplicationRecord
  has_many :deliveries
  belongs_to :team, optional: true

  geocoded_by :one_line
  after_validation :geocode
  
  def one_line
    return [street, city, postcode].join(', ') if company_name.nil?
    [company_name, street, city, postcode].join(', ')
  end

  def to_coordinates_s
    to_coordinates.join(',')
  end
end
