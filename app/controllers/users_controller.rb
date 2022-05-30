class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update ]
  before_action :authenticate_current_user_can_edit_user!, only: %i[ edit update ]

  def index
    redirect_to teams_path if !current_user.admin?
    @users = User.all.order(created_at: :desc).page params[:page]
  end

  # GET /users/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @user.update!(user_params)
        format.html { redirect_to edit_my_or_a_path, notice: "User was successfully updated." }
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
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :time_zone,
        :email, :role, :phone_number, :sms_opt_in,
        :team_id, :company_id
      )
    end

    def authenticate_current_user_can_edit_user!
      return if current_user.admin?
      return if current_user.team_admin? && current_user.team.part_of?(@user)
      return if current_user.company_admin? && current_user.company.part_of?(@user)
      redirect_to root_path, alert: "Whoops! You can't access this page." unless current_user == User.find(params[:id])
    end

    def edit_my_or_a_path
      if @user == current_user
        edit_my_user_path
      else
        edit_user_path(@user)
      end
    end
end
