class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Helps to give a default location in development
  # See: http://hankstoever.com/posts/11-Pro-Tips-for-Using-Geocoder-with-Rails
  def location
    if params[:location].blank?
      if Rails.env.test? || Rails.env.development?
        @location ||= Geocoder.search("50.78.167.161").first
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
    authenticated_root_path # your path
  end
end
