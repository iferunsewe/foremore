class Company < ApplicationRecord
  has_many :teams
  has_many :users
  has_one_attached :image

  validates_presence_of :name
  validates_uniqueness_of :name

  def part_of?(user)
    users.include?(user)
  end
end
