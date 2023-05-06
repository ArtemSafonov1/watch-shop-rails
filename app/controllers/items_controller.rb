class ItemsController < ApplicationController
  include CartsHelper
  layout false

  def create
    quantity = Product.find_by(:id => params[:product_id]).quantity
    if params[:quantity].to_i <= Product.find_by(:id => params[:product_id]).quantity && params[:quantity].to_i > 0
      cart_items.create!(item_params) 
      Product.find_by(:id => params[:product_id]).update!(quantity: quantity-params[:quantity].to_i)
    else
      render "wrong number"
    end
  end

  def destroy
    quantity = Product.find_by(:id => cart_items.find_by(item_params).product_id).quantity
    Product.find_by(:id => cart_items.find_by(item_params).product_id).update!(quantity: quantity+cart_items.find_by(item_params).quantity)
    cart_items.find_by(item_params).destroy
    render :create
  end

  private
  
  def item_params
    params.permit(:product_id, :quantity, :color, :size)
  end

  helper_method :products
end
