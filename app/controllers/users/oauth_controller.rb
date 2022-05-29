class Users::OauthController < ApplicationController
  include HTTParty

  def exact_callback
    begin
      token_response = retrieve_exact_token(params[:code])
      set_session_exact_variables(token_response)

      redirect_to settings_path, notice: "Exact Online was successfully linked."
    rescue => e
      redirect_to settings_path, alert: "Exact Online could not be linked. #{e.message}"
    end 
  end

  private

  def retrieve_exact_token(code)
    url = "https://start.exactonline.nl/api/oauth2/token"
    response = HTTParty.post(url, body: {
      client_id: Elmas.config[:client_id],
      client_secret: Elmas.config[:client_secret],
      grant_type: "authorization_code",
      redirect_uri: Elmas.config[:redirect_uri],
      code: code
    })
  end

  def set_session_exact_variables(token_response)
    session[:exact_token_expires_at] = Time.now + token_response["expires_in"].to_i
    session[:exact_refresh_token] = token_response["refresh_token"]
    session[:exact_access_token] = token_response["access_token"]
  end
end
