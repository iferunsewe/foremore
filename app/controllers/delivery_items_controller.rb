class DeliveryItemsController < ApplicationController
  def create
    if found_or_created_delivery_item
      @delivery_items = current_cart.delivery_items.where(active: true)
      respond_to do |format|
        format.turbo_stream { render "deliveries/new", notice: "Added to your delivery" }
      end
    else
      @delivery_items = current_cart.delivery_items.where(active: true)
      respond_to do |format|
        format.turbo_stream { render "deliveries/new", alert: "Something went wrong when adding the product to your delivery" }
      end
    end
  end

  def update
    @delivery_item = DeliveryItem.find(params[:id])
    if @delivery_item.update(delivery_item_params)
      @delivery_items = current_cart.delivery_items.where(active: true)
      respond_to do |format|
        format.turbo_stream { render "deliveries/new", notice: "Delivery updated" }
      end
    else
      @delivery_items = current_cart.delivery_items.where(active: true)
      respond_to do |format|
        format.turbo_stream { render "deliveries/new", alert: "Something went wrong when updating your delivery" }
      end
    end
  end

  private

  def delivery_item_params
    params.require(:delivery_item).permit(:product_id, :quantity, :active)
  end

  def found_or_created_delivery_item
    if @delivery_item = DeliveryItem.find_by({product_id: delivery_item_params[:product_id], cart_id: current_cart.id, active: true})
      @delivery_item.update(quantity: @delivery_item.quantity + delivery_item_params[:quantity].to_i)
    elsif @delivery_item = DeliveryItem.find_by({product_id: delivery_item_params[:product_id], cart_id: current_cart.id, active: false})
      @delivery_item.update(quantity: delivery_item_params[:quantity].to_i, active: true)
    else
      @delivery_item = DeliveryItem.create(delivery_item_params.merge({cart_id: current_cart.id}))
    end
  end
end
