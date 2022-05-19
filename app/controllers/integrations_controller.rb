class IntegrationsController < ApplicationController
  include Elmas::OAuth
  def find_order
    begin
      if authorized?
        @sales_order = Elmas::SalesOrder.new(order_number: params[:order_number].to_i).find_by(filters: [:order_number]).records.first
        session[:delivery] = build_delivery_from_sales_order(@sales_order)
        redirect_to new_delivery_path, notice: "Order #{@sales_order.order_number} was successfully retrieved."
      elsif Time.now > session[:exact_token_expires_at] && session[:exact_refresh_token].present?
        token_response = refresh_exact_token
        set_session_exact_variables(token_response)
        set_elmas_config
        raise "Exact Online is not authorized." unless authorized?
        @sales_order = Elmas::SalesOrder.new(order_number: params[:order_number].to_i).find_by(filters: [:order_number]).records.first
        session[:delivery] = build_delivery_from_sales_order(@sales_order) 
        redirect_to new_delivery_path, notice: "Order #{@sales_order.order_number} was successfully retrieved."
      elsif session[:exact_access_token].present?
        set_elmas_config
        raise "Exact Online is not authorized." unless authorized?
        @sales_order = Elmas::SalesOrder.new(order_number: params[:order_number].to_i).find_by(filters: [:order_number]).records.first
        session[:delivery] = build_delivery_from_sales_order(@sales_order)
        redirect_to new_delivery_path, notice: "Order #{@sales_order.order_number} was successfully retrieved."
      else
        redirect_to edit_user_registration_path, alert: "Please authorize with Exact."
      end
    rescue Elmas::BadRequestException => e
      redirect_to edit_user_registration_path, alert: "Please authorize with Exact."
    rescue => e
      redirect_to new_delivery_path, alert: e.message
    end
  end

  private

  def integration_params
    params.permit(:order_number)
  end

  def set_elmas_config
    Elmas.configure do |config|
      config.access_token = session[:exact_access_token]
      config.refresh_token = session[:exact_refresh_token]
      config.division = Elmas.get("/Current/Me", no_division: true).results.first.current_division
    end
  end

  def refresh_exact_token
    url = "https://start.exactonline.nl/api/oauth2/token"
    HTTParty.post(url, body: {
      client_id: ENV["EXACT_CLIENT_ID"],
      client_secret: ENV["EXACT_CLIENT_SECRET"],
      grant_type: "refresh_token",
      refresh_token: session[:exact_refresh_token]
    })
  end

  def set_session_exact_variables(token_response)
    session[:exact_token_expires_at] = Time.now + token_response["expires_in"].to_i
    session[:exact_refresh_token] = token_response["refresh_token"]
    session[:exact_access_token] = token_response["access_token"]
  end

  def build_delivery_from_sales_order(sales_order)
    delivery_address = get_delivery_address(sales_order)

    Delivery.new(
      order_reference: sales_order.order_number,
      recipient_name: sales_order.deliver_to_name,
      delivery_address: delivery_address
    )
  end

  def get_delivery_address(sales_order)
    address_id = sales_order.delivery_address
    return unless address_id.present?
    delivery_address = Elmas::Address.new(id: address_id).find

    address_components = [
      delivery_address.address_line1,
      delivery_address.address_line2,
      delivery_address.address_line3,
      delivery_address.city,
      delivery_address.postcode,
      delivery_address.country_name
    ]
    address_components.reject!(&:blank?)
    address_components.join(", ")
  end
end
