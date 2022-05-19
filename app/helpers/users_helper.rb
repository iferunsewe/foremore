module UsersHelper
  def exact_oauth_link
    "https://start.exactonline.nl/api/oauth2/auth?client_id=#{ENV["EXACT_CLIENT_ID"]}&redirect_uri=#{ENV["EXACT_REDIRECT_URI"]}&response_type=code"
  end
end
