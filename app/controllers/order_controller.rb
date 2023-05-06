class OrderController < ApplicationController
  include CartsHelper

  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find_by(user_id: current_user.id, id: params[:id])
    return not_found unless @order
  end

  def new
    @order = Order.new
  end

  def create
    order = current_user.orders.create!(comment: params[:order][:comment])
    current_cart.cart_items.each do |cart_item|
      order.orders_products.create!(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        color: cart_item.color,
        size: cart_item.size,
        price: cart_item.product.price
      )
    end
    current_cart.destroy
    OrderMailer.with(order: order).new_order_email.deliver_now
    respond_to do |format|
      format.html { redirect_to user_home_url, notice: "Successfully Created Order" }
    end
  end
  
  helper_method :products
end
