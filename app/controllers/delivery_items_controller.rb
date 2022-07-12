class DeliveryItemsController < ApplicationController
  def create
    @delivery_item = DeliveryItem.new(delivery_item_params.merge({cart_id: current_user.cart.id}))
    if @delivery_item.save
      flash[:notice] = "The product was added to your delivery"
      render "deliveries/new"
    else
      flash[:alert] = "The product could not be added to your delivery"
      render "deliveries/new"
    end
  end

  private

  def delivery_item_params
    params.require(:delivery_item).permit(:product_id, :quantity)
  end
end
