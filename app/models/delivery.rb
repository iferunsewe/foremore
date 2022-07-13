class Delivery < ApplicationRecord
  belongs_to :pickup_address, class_name: 'Address'
  belongs_to :user
  belongs_to :rider, class_name: 'User', optional: true

  enum status: [:draft, :pending, :confirmed, :ready, :delivering, :delivered]
  enum delivery_type: [:instant, :scheduled]
  enum weight_class: ["< 20", "< 120", "< 750"]
  enum length_class: ["< 1.4", "< 2.2", "< 3.4", "< 4.4"]

  validates_presence_of :pickup_address, :delivery_address, :delivery_type, :weight_class, :length_class, :status

  geocoded_by :delivery_address, latitude: :delivery_latitude, longitude: :delivery_longitude
  after_validation :geocode
  after_update :delivered_handler, if: :status_changed_to_delivered?
  after_update :confirmed_handler, if: :status_changed_to_confirmed?
  after_update :delivering_handler, if: :status_changed_to_delivering?
  after_update :ready_handler, if: :status_changed_to_ready?
  after_update :confirmed!, if: :no_rider_to_rider?

  scope :pending_and_in_the_future, -> { where(status: "pending", rider_id: nil).where("(delivery_type = 0 AND created_at > ?) OR (delivery_type = 1 AND scheduled_date > ?)", DateTime.now.beginning_of_day, DateTime.now) }

  def self.statuses_for_companies
    statuses.select { |k, _| k.in?(%w(pending ready)) }
  end

  def self.weight_i_to_weight_class(weight_i)
    return "< 20" if weight_i < 20
    return "< 120" if weight_i < 300
    return "< 750" if weight_i < 800
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

  def expected_time
    return scheduled_date if delivery_type == "scheduled" && scheduled_date.present?
    
    (created_at || DateTime.now) + travel_plus_prep_time.minutes
  end

  def travel_plus_prep_time
    default_travel_time = 20
    default_prep_time = 20
    (travel_time || default_travel_time) + (prep_time || default_prep_time)
  end

  def ineditable?
    status.in?(%w(ready delivering delivered))
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

  def status_changed_to_ready?
    !saved_change_to_status.nil? && saved_change_to_status[1] == "ready"
  end

  def send_confirmed_sms
    Sms::SendConfirmedSms.new(self).enqueue!
  end

  def send_delivering_sms
    Sms::SendDeliveringSms.new(self).enqueue!
  end

  def delivering_handler
    update(completion_pin: SecureRandom.random_number(9999), delivering_at: DateTime.now)
    send_delivering_sms
  end

  def send_delivered_sms
    Sms::SendDeliveredSms.new(self).enqueue!
  end

  def send_recipient_delivered_sms
    Sms::SendRecipientDeliveredSms.new(self).enqueue!
  end

  def delivered_handler
    send_delivered_sms
    send_recipient_delivered_sms
    update(delivered_at: DateTime.now)
  end

  def confirmed_handler
    send_confirmed_sms
    update(confirmed_at: DateTime.now)
  end

  def ready_handler
    update(ready_at: DateTime.now)
  end

  def no_rider_to_rider?
    !saved_change_to_rider_id.nil? && saved_change_to_rider_id[0].nil? && saved_change_to_rider_id[1].present?
  end
end
