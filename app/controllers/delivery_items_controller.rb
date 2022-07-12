class DeliveryItemsController < ApplicationController
  def create
    @delivery_item = DeliveryItem.new(delivery_item_params.merge({cart_id: current_user.cart.id}))
    if @delivery_item.save
      flash[:notice] = "The product was added to your delivery"
      redirect_to new_delivery_path
    else
      flash[:alert] = "The product could not be added to your delivery"
      redirect_to new_delivery_path
    end
  end

  def update
    @delivery_item = DeliveryItem.find(params[:id])
    if @delivery_item.update(delivery_item_params)
      flash[:notice] = "The product was updated"
      redirect_to new_delivery_path
    else
      flash[:alert] = "The product could not be updated"
      redirect_to new_delivery_path
    end
  end

  private

  def delivery_item_params
    params.require(:delivery_item).permit(:product_id, :quantity, :active)
  end
end
