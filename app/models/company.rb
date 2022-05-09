class Company < ApplicationRecord
  has_many :teams
  has_many :users
  has_one_attached :image

  validates_presence_of :name
  validates :image, attached: true
end
