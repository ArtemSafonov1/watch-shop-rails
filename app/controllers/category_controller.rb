class CategoryController < ApplicationController

  def show
    @category = Category.find_by(:id => params[:id])
    return not_found unless @category
    @categories_with_products = []
    @category.subtree.each{|subcategory| @categories_with_products.append(subcategory) unless subcategory.products.empty?}
    set_page_options
  end

  attr_accessor :category

  def set_page_options
    set_meta_tags category.slice(:title, :keywords, :description)
    add_breadcrumb 'Home', :root_path, title: 'Home'
  end

end
