class MainController < ApplicationController

  before_action :set_page_options

  def about
  end
  
  def index
    @brands = Brand.limit(3)
    @hits = Product.all.limit(8)
  end

  def set_page_options
    @page_title = 'Wathces shop'
    @page_description = 'Watches shop'
    @page_keywords = 'Man Woman Kids asd'
  end
end
