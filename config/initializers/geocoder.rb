Geocoder.configure(
  :timeout  => 20,
  :lookup   => :google,
  :ip_lookup => :google,
  :api_key  => ENV["GOOGLE_API_KEY"],
  :units    => :km,
  :cache    => Rails.cache
)
