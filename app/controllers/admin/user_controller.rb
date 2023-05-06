class Admin::UserController < Admin::BaseController

  before_action :authenticate_user!
  before_action :check_for_admin, except: :index

  def index
    @user = current_user
  end

  def show
    @user = User.find_by(:id => params[:id])
  end

  def users_managing
    @users = User.all
  end

  def edit_page
    @user = User.find_by(:id => params[:id])
    @admin = @user.admin?
  end

  def edit
    @user = User.find_by(:id => params[:id])
    if !params[:user][:password].blank?
      @user.update!(params.require(:user).permit(:first_name, :last_name, :country, :address, :phone, :email, :password, :admin))
      flash[:notice] = "Successfully updated User: #{@user.email}"
      redirect_to "/admin/manage-for-users"
    elsif params[:user][:password].blank?
      @user.update!(params.require(:user).permit(:first_name, :last_name, :country, :address, :phone, :email, :admin))
      flash[:notice] = "Successfully updated User: #{@user.email}"
      redirect_to "/admin/manage-for-users"
    else
      flash[:alert] = "Can't update User: #{@user.email}"
      redirect_to "/admin/manage-for-users"
    end
  rescue => e
    flash[:alert] = "Can't update User: #{@user.email}, #{e.message}"
    redirect_to "/admin/manage-for-users"
  end

  def destroy
    User.find(params[:id]).authorizations.destroy_all unless User.find(params[:id]).authorizations.empty?
    User.find(params[:id]).destroy
    redirect_back fallback_location: root_path,
      :notice => 'User was successfully deleted.'
  end

  def categories_managing

  end

  def reviews_managing

  end

  def about

  end

  def check_for_admin
    redirect_to root_path, alert: "You dont have access" unless current_user.try(:admin?)
  end

  def password_required?
    false
  end

end
