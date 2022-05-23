class Team < ApplicationRecord
  belongs_to :company
  has_many :users
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  validates_presence_of :name, :company_id

  def employees_count
    users.count
  end
end
