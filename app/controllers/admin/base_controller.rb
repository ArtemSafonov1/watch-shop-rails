class Admin::BaseController < ApplicationController
  
  before_action :authenticate_user!
  before_action :check_for_admin, except: :index
  
  def check_for_admin
    redirect_to root_path, alert: "You dont have access" unless current_user.try(:admin?)
  end
end