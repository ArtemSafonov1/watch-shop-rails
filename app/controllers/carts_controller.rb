class CartsController < ApplicationController
  layout false

  def destroy
    current_cart.cart_items.each do |cart_item|
      quantity = cart_item.quantity
      cart_item.product.update!(quantity: cart_item.product.quantity+quantity)
    end
    current_cart.destroy
    render :show
  end
end
