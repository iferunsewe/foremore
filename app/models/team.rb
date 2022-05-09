class Team < ApplicationRecord
  belongs_to :company
  has_many :users
  has_one :address, as: :addressable, dependent: :destroy
end
