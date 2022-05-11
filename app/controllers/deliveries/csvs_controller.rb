class Deliveries::CsvsController < ApplicationController

  # POST /delivery/csvs
  def create
    @delivery_csv = UploadDeliveryCsv.new(delivery_csv_params[:csv_file], current_user)
    @delivery_csv.process

    respond_to do |format|
      if @delivery_csv.successful?
        format.html { redirect_to deliveries_path, notice: "Deliveries were successfully created." }
      else
        format.html { redirect_to authenticated_root_path, status: :unprocessable_entity, alert: @delivery_csv.errors.join(", ") }
      end
    end
  end

  private 
  
  def delivery_csv_params
    params.permit(:csv_file)
  end
end
