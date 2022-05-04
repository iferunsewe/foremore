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
end
