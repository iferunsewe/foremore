module DeliveriesHelper
  def google_map(pickup_address:, delivery_address:nil)
    if delivery_address.nil?
      url = "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_API_KEY']}&q=#{pickup_address}"
    else
      url = "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_API_KEY']}&origin=#{pickup_address}&destination=#{delivery_address}&mode=bicycling&zoom=12"
    end
    url.gsub(/\s+/, '%20')
  end

  def google_map_fallback_url(pickup_address:)
    "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_API_KEY']}&q=#{pickup_address}"
  end

  def iframe_source(delivery:, alt_pickup_address: nil)
    if delivery.persisted?
      google_map(pickup_address: delivery.pickup_address.one_line, delivery_address: delivery.delivery_address)
    else
      google_map(pickup_address: alt_pickup_address.one_line)
    end
  end

  def statuses_to_display
    if current_user.admin?
      Delivery.statuses.keys.map{|status| [status.humanize, status]}
    else
      Delivery.statuses_for_companies.keys.map{|status| [status.humanize, status]}
    end
  end

  def pickup_address_to_use(delivery)
    if current_user.admin?
      delivery.pickup_address
    else
      current_user.team.address
    end
  end

  def format_expected_time(delivery)
    delivery.expected_time.in_time_zone("Europe/Amsterdam").strftime("%H:%M")
  end

  def format_expected_day(delivery)
    return "Today" if delivery.expected_time.in_time_zone("Europe/Amsterdam").today?
    return "Tomorrow" if delivery.expected_time.in_time_zone("Europe/Amsterdam").tomorrow?
    delivery.expected_time.in_time_zone("Europe/Amsterdam").strftime("%d/%m/%Y")
  end

end
