require 'open-uri'
require "addressable/uri"
class MainController < ApplicationController
	# helper :all # include all helpers, all the time
 #  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # before_action :authentication, :configure_api, only: [:edit, :update]
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # def index
  # 	#@orders = in_delivery # MyApp.get_delivery_id (params[:shop])
  # 	#@orders = MyApp.delivery_id #in_delivery
  # 	@orders = out_city #install_delivery_variant
  # end

  def edit

    url = "https://api.exline.systems/public/v1/regions/origins?country=KZ"
    @data = JSON.load(open(Addressable::URI.parse(url).normalize.to_s))['regions']

    Rails.logger.info "\n\n\ntoken: \"#{session[:app].inspect}\"\n
      password: \"\"\n
      \n\n\n"
    #icity = data.first.last.first.first.last #[0] #.['regions'] #.id.to_s #.id #.regions.first.id
    #session[:app] = MyApp.new(@account.insales_subdomain, @account.password)
    #account1 = Account.find(5)
    #@account.init_api
    #@deliveries = @account.find_deliveries #InsalesApi::DeliveryVariant.all
    #@deliveries = InsalesAppController::iii
    #byebug
    #@deliveries = MyDeliveries.all #InsalesApi::DeliveryVariant.all #.configure(MyApp.api_key, session["app"].domain, session["app"].password).all
    @deliveries = InsalesApi::DeliveryVariant.all #@account.find_deliveries
    #@deliveries = MyApp.get_deliveries
    #@deliveries = MyApp.get_deliveries
  end

  # def update
  #   respond_to do |format|
  #     if @account.update(account_params)
  #       format.html { redirect_to @account, notice: 'Device model was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @account }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @account.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
    if @account.store_city_id == 0
      #delivery =
      byebug
        MyApp.install_delivery_variant
      # delivery = InsalesApi::DeliveryVariant.new(
      #  :title => 'Курьер Exline Standard',
      #  :description => "ExLine - линия надежной доставки!",
      #  :type => "DeliveryVariant::External",
      #  :url => "http://rails.echelonsystems.ru/deliveries/standard/id/454613.json",
      #  :add_payment_gateways => true
      # )
      # delivery.save
      #MyApp.cache_delivery_id params[:shop], delivery.id
    end
    if @account.update(account_params)

      #redirect_to @account, notice: 'Account was successfully updated.', r: 'ddddd'
      #redirect_to :back
      #format.html { redirect_to action: "index", notice: 'Test was successfully created.' }
      flash[:notice] = I18n.t 'successfully_updated'
      redirect_to(controller: 'main', action: 'edit',
        insales_id: params[:insales_id],
        shop: params[:shop],
        user_email: params[:user_email],
        user_id: params[:user_id]
        )
      #redirect_to controller: 'main', action: 'edit', id: 3, :params   #, id: 3, something: 'else', notice: 'Account was successfully updated.'
      #redirect_to action: "index", notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  #def config
  	#@orders = MyApp.get_delivery_id (params[:shop])
  	#@orders = in_delivery
  	#@orders = InsalesApi::Account.find #install_delivery_variant
  #end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = account_by_params
    end

    def account_params
      #params.fetch(:account, {})
      params.require(:account).permit(:store_city_id, :pricing_policy)
    end

end
