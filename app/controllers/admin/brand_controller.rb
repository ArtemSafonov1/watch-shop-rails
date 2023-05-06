class Admin::BrandController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_for_admin

  def index
    @brands = Brand.all
  end
  
  def new
    @brand = Brand.new
  end

  def create
    if params[:brand][:title].blank? || params[:brand][:description].blank?
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, :alert => 'Title and description cant be blank' }
      end
      return
    end

    img_file = params[:brand][:img]
    if images_valudates?(img_file)
      if (brand = Brand.create!(brand_params)) && update_img(img_file, brand.id)
        respond_to do |format|
          format.html { redirect_to brand_path(brand.id), notice: "Successfully Created Brand: #{brand.title}" }
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't Create Brand: #{brand.title}" }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Brand #{brand.title} created. Can't update Brand: Wrong images type" }
      end
    end
  
  end

  def edit
    @brand = Brand.find_by(:id => params[:id])
    return redirect_to admin_brand_index_path if @brand.nil?
  end

  def update
    @brand = Brand.find_by(:id => params[:id])
    img_file = params[:brand][:img]

    if images_valudates?(img_file)
      if @brand.update!(brand_params) && update_img(img_file, @brand.id)
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, notice: "Successfully updated Brand: #{@brand.title}" }
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Can't update Brand: #{@brand.title}" }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't update Brand: #{@brand.title}. Wrong images type" }
      end
    end
  end

  def destroy
    brand = Brand.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, :notice => 'Brand was successfully deleted.' }
    end
  end

  def update_img(img_file, brand_id)
    unless img_file.nil?
      File.open(Rails.root.join('app', 'assets', 'images', img_file.original_filename), 'w+') do |file|
        file.write(img_file.read.force_encoding(Encoding::UTF_8))
      end
      Brand.find_by(:id => brand_id).update!(:img => img_file.original_filename)
    end
    return true
  end

  def images_valudates?(img_file = nil, uploaded_files = nil)
    return false unless img_file.content_type.include?("image/") unless img_file.nil?
    unless uploaded_files.nil?
      uploaded_files.each do |uploaded_file|
        return false unless uploaded_file.content_type.include?("image/")
      end
    end
    true
  end

  def brand_params
    params.require(:brand).permit(:title, :bytitle, :description)
  end
end