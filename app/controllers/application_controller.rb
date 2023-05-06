class ApplicationController < ActionController::Base

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :country, :address, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :country, :address, :phone])
  end
  
  def current_cart
    @current_cart ||= begin
      Cart.find_or_create_by(user: current_user)
    end
  end

  def cart_total
    return 0 if cart_items.none?

    cart_items.joins(:product).select('(cart_items.quantity * products.price) as total').sum {|x| x[:total]}
  end
  
  def cart_items
    current_cart.cart_items
  end

  helper_method :current_cart, :cart_items, :cart_total

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale.to_sym :
      nil
  end

  def not_found
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
