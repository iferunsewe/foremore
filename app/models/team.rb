class Team < ApplicationRecord
  belongs_to :company
  has_many :users
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  validates_presence_of :company_id

  def employees_count
    users.count
  end

  def part_of?(user)
    users.include?(user)
  end
end
