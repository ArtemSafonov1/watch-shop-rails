class ProductController < ApplicationController

  after_action :registed_visit, only: [:show], if: -> { @product }

  def index
    @products = Product.all.shuffle
  end

  def show
    if Product.find_by(:id => params[:id])
      @product = Product.find_by(:id => params[:id])
      @category = Category.find_by(:id => @product.category_id)
      @brand = @product.brand
      set_page_options
    else
      return not_found
    end
  end

  helper_method :recent_products
  attr_accessor :product

  def recent_products
    [] if recently.none?
    Product.where(id: recently)
  end

  def recently
    session[:viewed_products] ||= []
  end

  def registed_visit
    session[:viewed_products] ||= []
    session[:viewed_products] =([@product.id] + session[:viewed_products]).uniq.take(3)
  end


  def set_page_options
    set_meta_tags product.slice(:title, :keywords, :description)
    add_breadcrumb 'Home', :root_path, title: 'Home'
  end
end
