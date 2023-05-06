class Admin::OrderController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_for_admin

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by(:id => params[:id])
  end

  def edit
    @order = Order.find_by(:id => params[:id])
    return redirect_to admin_user_order_index_path if @order.nil?
    @collection = {"New": 0, "In Progress": 2, "Queue": 1, "Completed": 3, "Provided": 4, "Canselled": 5}.to_a
    @checked = @order.read_attribute_before_type_cast(:status)
  end

  def update
    @order = Order.find_by(:id => params[:id])
    if @order.update!(status: params[:order][:status].to_i)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, :notice => "Order № #{@order.id} was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't update Order: #{@order.id}" }
      end
    end
  end
  
  def destroy
    Order.find_by(:id => params[:id]).destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, :notice => 'Order was successfully deleted.' }
    end
  end
end