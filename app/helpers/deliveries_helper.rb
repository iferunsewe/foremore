module DeliveriesHelper
  def google_map(pickup_address:, delivery_address:nil)
    if delivery_address.nil?
      url = "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_API_KEY']}&q=#{pickup_address}"
    else
      url = "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_API_KEY']}&origin=#{pickup_address}&destination=#{delivery_address}&mode=bicycling&zoom=12"
    end
    url.gsub(/\s+/, '%20')
  end

  def google_map_fallback_url(pickup_address: nil)
    if pickup_address.blank?
      "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_API_KEY']}&q=#{default_location_for_new_delivery}"
    else
      "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_API_KEY']}&q=#{pickup_address.one_line}"
    end
  end

  def iframe_source(delivery:, alt_pickup_address: nil)
    if delivery.persisted?
      google_map(pickup_address: delivery.pickup_address.one_line, delivery_address: delivery.delivery_address)
    elsif alt_pickup_address.present?
      google_map(pickup_address: alt_pickup_address.one_line)
    else
      google_map(pickup_address: default_location_for_new_delivery)
    end
  end

  def default_location_for_new_delivery
    "100 Overtoom, Amsterdam"
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

  def pickup_addresses_to_display
    if current_user.admin?
      Team.all.map{|team| [team.address.one_line, team.address.id]}
    else
      current_user.company.teams.map{|team| [team.address.one_line, team.address.id]}
    end
  end

  def format_delivery_time(delivery_datetime)
    delivery_datetime.in_time_zone("Europe/Amsterdam").strftime("%H:%M")
  end

  def format_delivery_day(delivery_datetime)
    return "Today" if delivery_datetime.in_time_zone("Europe/Amsterdam").today?
    return "Tomorrow" if delivery_datetime.in_time_zone("Europe/Amsterdam").tomorrow?
    return "Yesterday" if delivery_datetime.in_time_zone("Europe/Amsterdam").yesterday?
    delivery_datetime.in_time_zone("Europe/Amsterdam").strftime("%d/%m/%Y")
  end

  def value_for_scheduled_date(delivery)
    if delivery&.scheduled_date.present?
      delivery.scheduled_date
    else
      DateTime.now
    end
  end

  def whatsapp_link(delivery)
    "https://api.whatsapp.com/send?phone=+31#{delivery.rider.phone_number}&text=I want to talk about the delivery #{delivery.id} to #{delivery.delivery_address}"
  end

  def when_is_delivery(delivery)
    return "ASAP" if delivery.instant?
    return delivery.scheduled_date.strftime('%Y-%m-%d %H:%M') if delivery.scheduled_date
  end
end
