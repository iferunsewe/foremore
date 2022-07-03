class Deliveries::PendingController < ApplicationController
  before_action :redirect_guest
  before_action :location

  def index
    @deliveries = Delivery.pending_and_in_the_future.where(pickup_address: current_user.team.address)
    if params[:query].present?
      @deliveries = @deliveries&.where("delivery_address ILIKE ?", "%#{params[:query]}%").order(updated_at: :desc).page params[:page]
    else
      @deliveries = @deliveries&.order(updated_at: :desc).page params[:page]
    end
  end
end
