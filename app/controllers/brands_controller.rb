class BrandsController < ApplicationController

  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find_by(:id => params[:id])
    return not_found unless @brand
    
    @products = Product.where(:brand_id => @brand.id)
  end
end
