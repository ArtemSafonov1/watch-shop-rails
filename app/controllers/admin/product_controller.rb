class Admin::ProductController < Admin::BaseController

  before_action :authenticate_user!
  before_action :check_for_admin

  def export
    respond_to :docx, :xlsx
    @product = Product.find_by(:id => params[:id])
    respond_to do |format|
      format.docx do
        render docx: 'export', filename: "#{@product.title}.docx"
      end
      format.xlsx do
        render xlsx: 'export', filename: "#{@product.title}"
      end
    end
  end

  def export_json
    product = Product.find_by(id: params[:id])
    file = File.write(Rails.root.join('app', 'assets', 'files', "#{product.bytitle}.json"), product.to_json)
    send_data(product.to_json, filename: "#{product.bytitle}.json", type: :json, disposition: "attachment",)
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(:id => params[:id])
  end

  def new
    @product = Product.new

    array = []
    Category.all.each do |category|
      values = ""
      category.path.each do |path|
        values = values + " " + path.title
      end
      array.append([values.strip, category.id])
    end
    @collection = array.uniq

    array = []
    Brand.all.each {|brand| array.append([brand.title, brand.id])}
    @brands = array.uniq

    if @product.status == "active"
      @status = 'active'
    else
      @status = 'not_active'
    end

    if @product.hit == "hit"
      @hit = 'hit'
    else
      @hit = 'not_hit'
    end
  end

  def create
    unless params[:product][:json_file].nil?
      if params[:product][:json_file].content_type.include?("json")
        if product = Product.create!(JSON.parse(File.read(params[:product][:json_file])))
          respond_to do |format|
            format.html { redirect_to product_path(product.id), notice: "Successfully Created Product: #{product.title}" }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product. Wrong type of file" }
        end
      end
    else
      if params[:product][:category].blank?
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: Category is empty" }
        end 
        return
      end
      if params[:product][:brand].blank?
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: Brand is empty" }
        end
        return
      end

      img_file = params[:product][:img]
      uploaded_files = params[:product][:image]

      if images_valudates?(img_file, uploaded_files)
        if (product = Product.create!(product_params)) && update_img(img_file, product.id) && update_images(uploaded_files, product.id)
          respond_to do |format|
            format.html { redirect_to product_path(product.id), notice: "Successfully Created Product: #{product.title}" }
          end
        else
          respond_to do |format|
            format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: #{product.title}" }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product. Wrong images type" }
        end
      end
    end
  rescue => e
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: #{e.message}" }
    end
  end

  def edit_page
    @user = User.find_by(:id => params[:id])
  end

  def edit
    @product = Product.find_by(:id => params[:id])
    return redirect_to admin_product_index_path if @product.nil?

    @category = @product.category
    array = []
    Category.all.each do |category|
      values = ""
      category.path.each do |path|
        values = values + " " + path.title
      end
      array.append([values.strip, category.id])
    end
    @collection = array.uniq
    @checked = ""

    if @category
      @category.path.each {|ancestor| @checked = @checked + " " + ancestor.title}
      @checked = @collection.each{|el| break el[1] if el[0] == @checked.strip}
    else
      @checked = nil
    end

    array = []
    Brand.all.each {|brand| array.append([brand.title, brand.id])}
    @brands = array.uniq
    @brands_checked = @product.brand.id if @product.brand

    if @product.status == "active"
      @status = 'active'
    else
      @status = 'not_active'
    end

    if @product.hit == "hit"
      @hit = 'hit'
    else
      @hit = 'not_hit'
    end
  end

  def update
    @product = Product.find_by(:id => params[:id])

    if params[:product][:category].blank?
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: Category is empty" }
      end 
      return
    end
    if params[:product][:brand].blank?
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: Brand is empty" }
      end
      return
    end

    img_file = params[:product][:img]
    uploaded_files = params[:product][:image]

    if images_valudates?(img_file, uploaded_files)
      if @product.update!(product_params) && update_img(img_file, @product.id) && update_images(uploaded_files, @product.id)
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, notice: "Successfully updated Product: #{@product.title}" }
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't update Product: #{@product.title}" }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't update Product: #{@product.title}. Wrong images type" }
      end
    end
  rescue => e
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: "Can't Create Product: #{e.message}" }
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to root_path, :notice => 'Product was successfully deleted.' }
    end
  end
  
  def destroy_gallery
    if Gallery.find_by(:id => params[:id]).destroy!
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, :notice => 'Image was successfully deleted.' }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, :alert => 'Image has not been deleted.' }
      end
    end
  end

  def images_valudates?(img_file, uploaded_files)
    return false unless img_file.content_type.include?("image/") unless img_file.nil?
    unless uploaded_files.nil?
      uploaded_files.each do |uploaded_file|
        return false unless uploaded_file.content_type.include?("image/")
      end
    end
    true
  end

  def update_img(img_file, product_id)
    unless img_file.nil?
      File.open(Rails.root.join('app', 'assets', 'images', img_file.original_filename), 'w+') do |file|
        file.write(img_file.read.force_encoding(Encoding::UTF_8))
      end
      Product.find_by(:id => product_id).update!(:img => img_file.original_filename)
    end
    return true
  end

  def update_images(uploaded_files, product_id)
    unless uploaded_files.nil?
      product = Product.find_by(:id => product_id)
      uploaded_files.each do |uploaded_file|
        p "file #{uploaded_file.original_filename} uploaded"
        File.open(Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename), 'w+') do |file|
          file.write(uploaded_file.read.force_encoding(Encoding::UTF_8))
        end
        product.galleries.create!(img: uploaded_file.original_filename)
      end
    end
    return true
  end

  def product_params
    params.require(:product).permit(
      :title, :bytitle, :content,
      :price, :old_price, :keywords,
      :description, :status, :hit,
      :quantity
    ).merge(
      :category_id => Category.find_by(:id => params[:product][:category].to_i).id,
      :brand_id => Brand.find_by(:id => params[:product][:brand].to_i).id
    )
  end
end