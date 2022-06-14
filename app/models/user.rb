class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :trackable

  validates_uniqueness_of :email

  belongs_to :team, optional: true
  belongs_to :company, optional: true
  has_many :deliveries

  enum role: [:normal, :team_admin, :company_admin, :admin, :rider]

  after_update :normal!, if: :joining_a_company?
  after_update :normal!, if: :joining_a_team?
  after_update :team_admin!, if: :first_team_member?
  after_update :company_admin!, if: :first_company_member?
  after_commit :assign_team_and_company

  def guest?
    persisted?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def completed_user_account?
    first_name.present? && last_name.present? && phone_number.present?
  end

  private

  def joining_a_team?
    return false if saved_change_to_team_id.nil?
    saved_change_to_team_id[0].nil?
  end

  def joining_a_company?
    return false if saved_change_to_company_id.nil?
    saved_change_to_company_id[0].nil?
  end

  def first_team_member?
    return false if saved_change_to_team_id.nil?
    team&.users&.count == 1
  end

  def first_company_member?
    return false if saved_change_to_company_id.nil?
    company&.users&.count == 1
  end

  def assign_team_and_company
    return false if !invited_by || (team.present? || company.present?)
    team_id = invited_by.team.id
    company_id = invited_by.company.id
    update_attribute(:team_id, team_id)
    update_attribute(:company_id, company_id)
    update_attribute(:role, "normal")
  end
end
