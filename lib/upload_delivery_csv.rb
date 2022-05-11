require 'csv'

class UploadDeliveryCsv
  attr_reader :errors, :csv_file, :user
  
  def initialize(csv_file, user)
    @csv_file = csv_file
    @user = user
    @errors = []
  end

  def successful?
    @errors.empty?
  end

  def process
    begin
      CSV.foreach(@csv_file.path, headers: true) do |row|
        if row['id'].present?
          delivery = Delivery.find(row['id'])
          compact_delivery_params = delivery_params(row, delivery).compact
          delivery.update(compact_delivery_params)
        else
          delivery = Delivery.new(delivery_params(row))
          delivery.save
        end
      end
    rescue CSV::MalformedCSVError => e
      @errors << "The file you uploaded is not a valid CSV file."
    rescue ActiveRecord::RecordInvalid => e
      @errors << "One of the existing deliveries you uploaded is invalid."
    rescue => e
      @errors << "Something went wrong while processing your file."
    end
  end

  private

  def delivery_params(row, delivery=nil)
    params = {}
    params[:status] = "pending"
    params[:pickup_address_id] = @user.team.address.id
    params[:delivery_address] = delivery&.delivery_address || row['delivery_address']
    params[:delivery_type] = delivery&.delivery_type || row['delivery_type']
    params[:weight_class] = delivery&.weight_class || yrow['weight_class']
    params[:length_class] = delivery&.length_class || row['length_class']
    params[:order_reference] = row['order_reference']
    params[:other_notes] = row['other_notes']
    params[:address_notes] = row['address_notes']
    params[:recipient_name] = row['recipient_name']
    params[:recipient_email] = row['recipient_email']
    params[:recipient_phone] = row['recipient_phone']
    params[:scheduled_date] = row['scheduled_date']
    params[:description] = row['description']
    params
  end
end