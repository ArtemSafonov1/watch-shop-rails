class UserController < ApplicationController

  before_action :authenticate_user!
  before_action :check_for_admin, except: :index

  def index
    @user = current_user
  end

  def check_for_admin
    redirect_to root_path, alert: "You dont have access" unless current_user.try(:admin?)
  end

  def password_required?
    false
  end

  helper_method :products
end
