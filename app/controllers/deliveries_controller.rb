class DeliveriesController < ApplicationController
  before_action :redirect_guest
  before_action :set_delivery, only: %i[ show edit update destroy ]
  before_action :location
  before_action :redirect_to_pending_deliveries, only: [:new, :edit]

  # GET /deliveries or /deliveries.json
  def index
    if current_user&.admin?
      if params[:query].present?
        @deliveries = Delivery.where("delivery_address ILIKE ?", "%#{params[:query]}%").order(updated_at: :desc).page params[:page]
      else
        @deliveries = Delivery.all.order(updated_at: :desc).page params[:page]
      end
   else
    current_user_deliveries =  Delivery.where(pickup_address: current_user.team.address)
    if params[:query].present?
      @deliveries = current_user_deliveries&.where("delivery_address ILIKE ?", "%#{params[:query]}%").order(updated_at: :desc).page params[:page]
    else
      @deliveries = current_user_deliveries&.order(updated_at: :desc).page params[:page]
    end
   end
  end

  # GET /deliveries/1 or /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    if params[:old_delivery_id] && old_delivery = Delivery.find(params[:old_delivery_id])
      @delivery = old_delivery.dup
    else
      @delivery = session[:delivery] || Delivery.new
    end
    @products = Product.first(6)
    @delivery_items = current_cart.delivery_items
    @delivery_item_products = current_cart.products
  end

  # GET /deliveries/1/edit
  def edit
    if current_user.rider?
      redirect_to root_path, alert: "Whoops! You can't access this page."
    elsif !current_user.admin? && @delivery.ineditable?
      redirect_to @delivery, alert: "This delivery is on it's way or has been delivered so it can't be edited."
    end
  end

  # POST /deliveries or /deliveries.json
  def create
    @delivery = Delivery.new(custom_delivery_params)

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to delivery_url(@delivery), notice: "Delivery was successfully created." }
        format.json { render :show, status: :created, location: @delivery }
        send_new_delivery_sms
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1 or /deliveries/1.json
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to delivery_url(@delivery), notice: "Delivery was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery }
        send_ready_to_pickup_sms
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @delivery = Delivery.find(params[:id])
    if @delivery.completion_pin == params[:completion_pin].to_i
      @delivery.update(status: "delivered")
      redirect_to @delivery, notice: "Delivery was successfully delivered."
    else
      redirect_to @delivery, alert: "Incorrect completion pin."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def delivery_params
      params.require(:delivery).permit(
        :status, :pickup_address_id, :delivery_address,
        :delivery_type, :weight_class, :length_class,
        :order_reference, :other_notes, :scheduled_date,
        :description, :address_notes, :recipient_name,
        :recipient_email, :recipient_phone, :travel_time,
        :prep_time, :rider_id
      )
    end

    def custom_delivery_params
      delivery_params.merge(
        user_id: current_user.id
      )
    end

    def send_new_delivery_sms
      User.admin.each do |admin|
        Sms::SendNewDeliverySms.new(@delivery, admin).enqueue!
      end
      User.rider.each do |rider|
        # TODO Replace if condition with query
        Sms::SendRiderNewDeliverySms.new(@delivery, rider).enqueue! if @delivery.pickup_address == rider.team.address
      end
    end

    def send_ready_to_pickup_sms
      if @delivery.ready?
        User.admin.each do |admin|
          Sms::SendReadyToPickupSms.new(@delivery, admin).enqueue!
        end
        Sms::SendReadyToPickupSms.new(@delivery, @delivery.rider).enqueue!
      end
    end

    def redirect_to_pending_deliveries
      redirect_to pending_deliveries_path if current_user.rider?
    end
end
