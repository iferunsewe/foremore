class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.search(params[:query]).first(6)
    @delivery = Delivery.last
    @delivery_items = current_cart.delivery_items
    @delivery_item_products = current_cart.products
    render "deliveries/new"
  end
end
