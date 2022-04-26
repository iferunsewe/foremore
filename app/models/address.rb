class Address < ApplicationRecord
  has_many :deliveries
  
  def one_line
    return [street, city, postcode].join(', ') if company_name.nil?
    [company_name, street, city, postcode].join(', ')
  end
end
