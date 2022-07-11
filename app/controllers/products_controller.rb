class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.search(params[:query]).first(6)
    @delivery = Delivery.last
    @added_products = Product.where(id: session[:added_product_ids])
    render "deliveries/new"
  end

  def add_to_delivery
    session[:added_product_ids] ||= []
    session[:added_product_ids] << params[:product_id]
    @products = Product.search(params[:query]).first(6)
    @added_products = Product.where(id: session[:added_product_ids])
    @delivery = Delivery.last
    render "deliveries/new"
  end

  def remove_from_delivery
    session[:added_product_ids].delete(params[:product_id])
    @products = Product.search(params[:query]).first(6)
    @added_products = Product.where(id: session[:added_product_ids])
    @delivery = Delivery.last
    render "deliveries/new"
  end
end
