class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :authenticate_current_user_can_edit_team!, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    if current_user.admin?
      @teams = Team.all
    else
      @teams = current_user.company.teams
    end
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new(company_id: current_user.company_id)
    @team.build_address
  end

  # GET /teams/1/edit
  def edit
    @team.build_address if @team.address.nil?
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params_with_company_id)

    respond_to do |format|
      if @team.save
        format.html { redirect_to my_or_a_path, notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params_with_company_id)
        format.html { redirect_to my_or_a_path, notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      if params[:id]
        @team = Team.find(params[:id])
      else
        @team = current_user.team
      end
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:company_id, address_attributes: [:id, :street, :city, :postcode, :company_name, :country])
    end

    def team_params_with_company_id
      return team_params if current_user.admin?
      team_params.merge(company_id: current_user.company_id)
    end

    def authenticate_current_user_can_edit_team!
      return if current_user.admin?
      return if current_user.team_admin? && @team.part_of?(current_user)
      return if current_user.company_admin? && @team.company.part_of?(current_user)
      return if current_user.team == @team && action_name == 'show'
      redirect_to root_path, alert: "Whoops! You can't access this page."
    end

    def my_or_a_path
      if current_user.admin? || current_user.company_admin?
        team_path(@company)
      else
        my_team_path
      end
    end
end
