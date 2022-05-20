module UsersHelper
  def exact_oauth_link
    "https://start.exactonline.nl/api/oauth2/auth?client_id=#{Elmas.config[:client_id]}&redirect_uri=#{Elmas.config[:redirect_uri]}&response_type=code"
  end
end
