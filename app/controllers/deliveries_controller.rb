class DeliveriesController < ApplicationController
  before_action :set_delivery, only: %i[ show edit update destroy ]

  # GET /deliveries or /deliveries.json
  def index
    if current_user&.admin?
      if params[:query].present?
        @deliveries = Delivery.where("delivery_address ILIKE ?", "%#{params[:query]}%").order(created_at: :desc)
      else
        @deliveries = Delivery.all.order(created_at: :desc)
      end
   else
    current_user_deliveries =  Delivery.where(pickup_address: current_user.team.address)
    if params[:query].present?
      @deliveries = current_user_deliveries&.where("delivery_address ILIKE ?", "%#{params[:query]}%").order(created_at: :desc)
    else
      @deliveries = current_user_deliveries&.order(created_at: :desc)
    end
   end
  end

  # GET /deliveries/1 or /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    redirect_to settings_path if current_user.team.nil?
    if params[:old_delivery_id] && old_delivery = Delivery.find(params[:old_delivery_id])
      @delivery = old_delivery.dup
    else
      @delivery = session[:delivery] || Delivery.new
    end
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries or /deliveries.json
  def create
    @delivery = Delivery.new(delivery_params_to_i)

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
      if @delivery.update(delivery_params_to_i)
        format.html { redirect_to delivery_url(@delivery), notice: "Delivery was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery }
        send_ready_to_pickup_sms
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1 or /deliveries/1.json
  def destroy
    @delivery.destroy

    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: "Delivery was successfully destroyed." }
      format.json { head :no_content }
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
        :prep_time
      )
    end

    def delivery_params_to_i
      delivery_params.merge(
        delivery_type: delivery_params[:delivery_type].to_i,
        weight_class: delivery_params[:weight_class].to_i,
        length_class: delivery_params[:length_class].to_i,
        user_id: current_user.id
      )
    end

    def send_new_delivery_sms
      User.admin.each do |admin|
        Sms::SendNewDeliverySms.new(@delivery, admin).enqueue!
      end
    end

    def send_ready_to_pickup_sms
      if @delivery.ready?
        User.admin.each do |admin|
          Sms::SendReadyToPickupSms.new(@delivery, admin).enqueue!
        end
      end
    end
end
