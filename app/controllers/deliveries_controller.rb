require 'byebug'
require 'open-uri'
require "addressable/uri"
class DeliveriesController  < ActionController::Base #< ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]
  #protect_from_forgery
  #skip_before_action :verify_authenticity_token, :authentication #, :configure_api,
  #  if: [:calc, :load_account, :pricing_policy ]

  API_ROOT_URL = 'https://api.exline.systems/public/v1/'
  API_REGIONS_URL = "#{API_ROOT_URL}regions/"

  def get_json url
    JSON.load(open(Addressable::URI.parse(API_ROOT_URL + url).normalize.to_s))
  end

  def pricing_policy
    if @acc["pricing_policy"] != 'default'
      "&pricing_policy=#{@acc["pricing_policy"]}"
    else
      ''
    end
  end

  def load_account id
    #account =
    Account.find_by(insales_id: id)
    #session[:app] = MyApp.new(account.insales_subdomain, account.password)
    #session[:out_city] = InsalesApi::Account.find.city
    #account
    #if Account.store_city_id == 0
    #  url = "regions/origin?title=#{InsalesApi::Account.find.city}"
    #  data = get_json url
    #end
  end

  def calc
    #byebug
    @acc = load_account params[:insales_id]
    service = params[:service] || "standard"
    #p = "&pricing_policy=#{pricing_policy}" || ''
    #p = ''
    p = pricing_policy
    #logger.warn("session info " + session['app'].inspect)
    #url = "regions/origin?title=#{InsalesApi::Account.find.city}"
    #data = get_json url

    #if data['meta']['total'] != 0
    #  icity = data["regions"].first["id"]
    #else
    #  icity = nil
    #  render :json => { error: "Отправка невозможна" },
    #    :callback => params['callback']
    #end
    icity = @acc["store_city_id"] #.store_city_id

    if icity != 0 # && !icity.nil?
      #if params[:city].nil?
      url = "regions/destination?title='#{params[:city]}'"
      data = get_json url
      if data['meta']['total'] != 0
        dcity =  data["regions"].first["id"]
        logger.warn("dump dcity " + dcity.inspect)
        #render :json => dcity, :callback => params['callback']
      else
        data = nil
        render :json => { error: "Невозможно доставить в данный город" },
          :callback => params['callback']
      end
    end

    if icity != 0 && !dcity.nil?
      url = "calculate?origin_id=#{icity}&destination_id=#{dcity}&weight=#{params[:weight]}&service=#{service}#{p}"

      data = get_json url
      #dcity =  data["regions"].first["id"]
      #render :json => data["calculation"]
      price = data["calculation"]["price"] + data["calculation"]["fuel_surplus"]
      render :json => { error: "Ориентировочная доставка #{data["calculation"]["human_range"]}",
        delivery_price: price }, :callback => params['callback']
    end





    #:error = "Отправка не возможна" #}, :callback => params['callback']
    #icity = data.first.last.first.first.last #[0] #.['regions'] #.id.to_s #.id #.regions.first.id

    #url = "regions/destination?title=#{params[:city]}"
    #data = get_json url
    #dcity = data.first.last.first.first.last
    #if data['meta']['total'] == 0
    #  render :json => { error: "Невозможно доставить в данный город" },
    #  :callback => params['callback']
    #end
    #url = "calculate?origin_id=#{icity}&destination_id=#{dcity}&weight=#{params[:weight]}&service=#{service}"
    #data = get_json url
    #price = data.first.last.first.last.first.last
    #render :json => data
    #render :json => data["calculation"]["fuel_surplus"]
    #render :json => data["calculation"]["human_range"]
    #render :json => icity
    #price = data["calculation"]["price"] + data["calculation"]["fuel_surplus"]
    #render :json => { error: "Ориентировочная доставка #{data["calculation"]["human_range"]}",
    #  delivery_price: price }, :callback => params['callback']
    #params[:service]
  end

  def calc_standart

    url = "regions/origin?title=#{out_city}"
    data = get_json url
    icity = data.first.last.first.first.last #[0] #.['regions'] #.id.to_s #.id #.regions.first.id

    url = "regions/destination?title=#{params[:city]}"
    data = get_json url
    dcity = data.first.last.first.first.last

    url = "calculate?origin_id=#{icity}&destination_id=#{dcity}&weight=#{params[:weight]}"
    data = get_json url
    price = data.first.last.first.last.first.last
    #puts data
    #render :json => data[:standard] #.first.last.first.last.first.last #.last #[:price] #[:standard]
    #render :json => { error: 'Ориентировочная доставка 19 – 20 сентября', delivery_price: price }, :callback => params['callback']


    # :json => response.to_json,
    #jQuery16204684495358521503_1361805225262({delivery_price: 100})
    respond_to do |format|
      format.html  :template => "deliveries/index.json.erb"
    #  format.json render :template => "deliveries/index.json.erb"
    end
  end

  # GET /deliveries
  def index
    @deliveries = Delivery.all
  end

  # GET /deliveries/1
  def show
  end

  # GET /deliveries/new
  def new
    @delivery = Delivery.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries
  def create
    @delivery = Delivery.new(delivery_params)

    if @delivery.save
      redirect_to @delivery, notice: 'Delivery was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /deliveries/1
  def update
    if @delivery.update(delivery_params)
      redirect_to @delivery, notice: 'Delivery was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /deliveries/1
  def destroy
    @delivery.destroy
    redirect_to deliveries_url, notice: 'Delivery was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def delivery_params
      params.fetch(:delivery, {})
    end
end
