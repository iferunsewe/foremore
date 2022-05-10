class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :trackable

  validates_uniqueness_of :email

  belongs_to :team, optional: true
  belongs_to :company, optional: true

  enum role: [:normal, :team_admin, :company_admin, :admin]

  def guest?
    persisted?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
