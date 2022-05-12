class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update ]

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
end
