Elmas.configure do |config|
  config.client_id = ENV['EXACT_CLIENT_ID']
  config.client_secret = ENV['EXACT_CLIENT_SECRET']
  config.redirect_uri = ENV['EXACT_REDIRECT_URI']
end
