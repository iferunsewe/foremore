class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Helps to give a default location in development
  # See: http://hankstoever.com/posts/11-Pro-Tips-for-Using-Geocoder-with-Rails
  def location
    if params[:location].blank?
      if Rails.env.test? || Rails.env.development?
        @location ||= Geocoder.search("52.37307,4.892647").first
      else
        @location ||= request.location
      end
    else
      params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
      @location ||= Geocoder.search(params[:location]).first
      @location
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.admin? && current_user.completed_user_account? || current_user.completed_user_account? && current_user.has_team?
      authenticated_root_path
    elsif current_user.completed_user_account? && current_user.company_admin? && !current_user.has_team?
      flash[:notice] = "You should create a team first."
      new_team_path
    else
      flash[:notice] = "Please complete your account before continuing."
      edit_my_user_path
    end
  end

  def redirect_guest
    redirect_to edit_my_user_path, alert: "Whoops! You can't access this page." if current_user.guest?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end

