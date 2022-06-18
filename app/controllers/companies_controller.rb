class CompaniesController < ApplicationController
  before_action :redirect_guest
  before_action :set_company, only: %i[ show edit update destroy ]
  before_action :authenticate_current_user_can_edit_company!, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    @companies = Company.all.order(created_at: :desc).page params[:page]
  end

  # GET /companies/1 or /companies/1.json
  def show
    @company_teams = @company.teams.order(created_at: :desc).page params[:page]
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to edit_my_or_a, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)

        format.html { redirect_to edit_my_or_a, notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      if params[:id]
        @company = Company.find(params[:id])
      else
        @company = current_user.company
      end
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :tax_id, :image)
    end

    def authenticate_current_user_can_edit_company!
      return if current_user.admin?
      return if current_user.company_admin? && @company.part_of?(current_user)
      redirect_to root_path, alert: "Whoops! You can't access this page."
    end

    def edit_my_or_a
      if current_user.admin?
        edit_company_path(@company)
      else
        edit_my_company_path
      end
    end
end
