class Team < ApplicationRecord
  belongs_to :company
  has_many :users
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
end
