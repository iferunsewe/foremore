class Delivery < ApplicationRecord
  belongs_to :pickup_address, class_name: 'Address'
  belongs_to :user

  enum status: [:draft, :pending, :confirmed, :preparing, :ready, :delivering, :delivered]
  enum delivery_type: [:instant, :scheduled]
  enum weight_class: ["< 15", "15 - 300", "300 - 800"]
  enum length_class: ["< 1.4", "1.4 - 2.2", "2.2 - 3.4", "3.4 - 4.4"]

  validates_presence_of :pickup_address, :delivery_address, :delivery_type, :weight_class, :length_class, :status

  geocoded_by :delivery_address, latitude: :delivery_latitude, longitude: :delivery_longitude
  after_validation :geocode
  after_update :send_delivered_sms_and_update_delivered_at, if: :status_changed_to_delivered?
  after_update :send_confirmed_sms, if: :status_changed_to_confirmed?
  after_update :send_delivering_sms, if: :status_changed_to_delivering?

  def self.statuses_for_companies
    statuses.select { |k, _| k.in?(%w(draft pending preparing ready)) }
  end

  def self.weight_i_to_weight_class(weight_i)
    return "< 15" if weight_i < 15
    return "15 - 300" if weight_i < 300
    return "300 - 800" if weight_i < 800
  end

  def to_coordinates_s
    to_coordinates.join(',')
  end

  def pickup_address_to_s
    pickup_address.one_line
  end

  def company_name
    return pickup_address.company_name if pickup_address.company_name.present?
    return pickup_address.team.company&.name if pickup_address.team.present?
    return user.company&.name if user.present?
    nil
  end

  private

  def update_delivered_at
    update(delivered_at: DateTime.now)
  end

  def status_changed_to_delivered?
    !saved_change_to_status.nil? && saved_change_to_status[1] == "delivered"
  end

  def status_changed_to_confirmed?
    !saved_change_to_status.nil? && saved_change_to_status[1] == "confirmed"
  end

  def status_changed_to_delivering?
    !saved_change_to_status.nil? && saved_change_to_status[1] == "delivering"
  end

  def send_confirmed_sms
    Sms::SendConfirmedSms.new(self).enqueue!
  end

  def send_delivering_sms
    Sms::SendDeliveringSms.new(self).enqueue!
  end

  def send_delivered_sms
    Sms::SendDeliveredSms.new(self).enqueue!
  end

  def send_delivered_sms_and_update_delivered_at
    send_delivered_sms
    update_delivered_at
  end
end
