# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_action :authentication, :configure_api

  protected

  def authentication
    logout if enter_from_different_shop?

    if current_app and current_app.authorized?
      return if @account = Account.find_by(insales_subdomain: current_app.domain)
    end

    store_location

    if account_by_params
      init_authorization account_by_params
    else
      redirect_to login_path
    end
  end

  def logout
    reset_session
  end

  def configure_api
    current_app.configure_api
  end

  def init_authorization account
    session[:app] = MyApp.new(account.insales_subdomain, account.password)
    #byebug
    #  zzzzz1 = self.password_by_token(token)
    #  zzzzz2 = MyApp.password_by_token(token)
    #  zzzzz3 = password_by_token(token)
    # zzzzz3 = session[:app].inspect
    # byebug

    redirect_to session[:app].authorization_url
  end

  def store_location(path = nil)
    session[:return_to] = path || request.fullpath
  end

  def location
    session[:return_to]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def enter_from_different_shop?
    current_app and !params[:shop].blank? && params[:shop] != current_app.domain
  end

  def account_by_params
    @account ||= if params[:insales_id]
      Account.find_by insales_id: params[:insales_id]
    else
      Account.find_by insales_subdomain: params[:shop]
    end
  end

  def current_app
    session[:app]
  end

  def in_delivery
    InsalesApi::DeliveryVariant.all
  end

  def some
    session[:out_city] = InsalesApi::Account.find.city

  end

  def out_city
    session[:out_city]
  end

  public



  # def install_delivery_variant
  #   # MyApp.configure_api(current_app.domain, current_app.password)
  #   # self.current_app.configure_api
  #   # InsalesApi::DeliveryVariant.all
  #   # InsalesApi::Account.find
  #   delivery = InsalesApi::DeliveryVariant.new(
  #    :title => 'Курьер Exline Standard',
  #    :description => "ExLine - линия надежной доставки!",
  #    :type => "DeliveryVariant::External",
  #    :add_payment_gateways => true
  #   )
  #   delivery.save
  #   MyApp.cache_delivery_id params[:shop], delivery.id
  # end


  def delete_delivery_variant
    InsalesApi::DeliveryVariant.find(1191309).destroy
  end


end
