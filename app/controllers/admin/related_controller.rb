class Admin::RelatedController < Admin::ProductController

  before_action :authenticate_user!
  before_action :check_for_admin

  def index
    @products = Product.all
  end

  def edit
    @product = Product.find_by(:id => params[:id])
    @related_products = @product.related_products
  end

  def update
    @product = Product.find_by(:id => params[:id])
    @product.related_products.destroy_all
    params[:product][:related_ids].reject(&:empty?).map(&:to_i).each do |related|
      @product.related_products.create!(:related_id => related)
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_product_related_index_path, notice: "Successfully updated Brand: #{@product.title}" }
    end
  end
end