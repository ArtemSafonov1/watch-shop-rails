class OrderMailer < ApplicationMailer
  def new_order_email
    @order = params[:order]
    mail(to: ENV['SENDMAIL_USERNAME'], subject: "You got a new order!")
    mail(to: @order.user.email, subject: "You got a new order!")
  end
end
