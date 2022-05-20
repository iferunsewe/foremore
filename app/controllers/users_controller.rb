class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update ]
  include HTTParty

  def index
    redirect_to teams_path if !current_user.admin?
    @users = User.all.order(created_at: :desc)
  end

  # GET /users/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @user.update!(user_params)
        format.html { redirect_to edit_user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def exact_callback
    begin
      token_response = retrieve_exact_token(params[:code])
      set_session_exact_variables(token_response)

      redirect_to edit_user_registration_path, notice: "Exact Online was successfully linked."
    rescue => e
      redirect_to edit_user_registration_path, alert: "Exact Online could not be linked. #{e.message}"
    end 
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :time_zone,
        :email, :role, :phone_number, :sms_opt_in
      )
    end

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
