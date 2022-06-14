class Company < ApplicationRecord
  has_many :teams
  has_many :users
  has_one_attached :image do |attachable|
    attachable.variant :header_logo, resize_to_fit: [200, 200]
  end

  validates_presence_of :name
  validates_uniqueness_of :name

  def part_of?(user)
    users.include?(user)
  end
end
