Elmas.configure do |config|
  config.client_id = Rails.application.credentials.dig(:exact, :client_id)
  config.client_secret = Rails.application.credentials.dig(:exact, :client_secret)
  config.redirect_uri = ENV['EXACT_REDIRECT_URI']
end
