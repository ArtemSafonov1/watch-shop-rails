class Admin::CategoryController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_for_admin

  def new
    @category = Category.new
    array = [["",0]]
    Category.all.each do |category|
      values = ""
      next if @category.id.in?(category.path_ids)
      category.path.each do |path|
        values = values + " " + path.title
      end
      array.append([values.strip, category.id])
    end
    @collection = array.uniq
  end

  def edit
    @category = Category.find_by(:id => params[:id])
    return redirect_to admin_category_index_path if @category.nil?
    array = [["",0]]
    Category.all.each do |category|
      values = ""
      next if @category.id.in?(category.path_ids)
      category.path.each do |path|
        values = values + " " + path.title
      end
      array.append([values.strip, category.id])
    end
    @collection = array.uniq
    @checked = ""
    @category.ancestors.each {|ancestor| @checked = @checked + " " + ancestor.title}
    @checked = @collection.each{|el| break el[1] if el[0] == @checked.strip}
  end

  def update
    @category = Category.find_by(:id => params[:id])

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: "Can't update Product: #{@category.title}. Wrong Title or Bytitle" }
    end if params[:category][:title].blank? || params[:category][:bytitle].blank?

    if @category.update!(category_params)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Successfully updated Category: #{@category.title}" }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't update Category: #{@category.title}" }
      end
    end
  end

  def create
    if params[:category][:title].blank? || params[:category][:bytitle].blank?
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, :alert => 'Title and ByTitle cant be blank' }
      end
      return
    end
    if (category = Category.create!(category_params))
      respond_to do |format|
        format.html { redirect_to category_path(category.id), notice: "Successfully Created Category: #{category.title}" }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Can't Create Category: #{category.title}" }
      end
    end
  end

  def index
    @categories = Category.all
  end

  def destroy
    category = Category.find(params[:id])
    category.subtree.reverse_each do |subcategory|
      subcategory.destroy
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, :notice => 'Category and related subcategories was successfully deleted.' }
    end
  end

  def category_params
    return params.require(:category).permit(:title, :bytitle, :keywords, :description).merge(parent: nil) if params[:category][:ancestry].to_i == 0
    params.require(:category).permit(:title, :bytitle, :keywords, :description).merge(parent: Category.find_by(:id => params[:category][:ancestry].to_i))
  end
end