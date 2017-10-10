class MyApp < InsalesApi::App
  class << self

    def install shop, token, insales_id, delivery_id, store_city_id, pricing_policy
      shop = self.prepare_domain shop
      #logger.warn("token " + token.inspect)
      return true if Account.find_by(insales_subdomain: shop)
      Rails.logger.info "\n\n\ntoken: \"#{token}\"\n
      password: \"#{password_by_token(token)}\"\n
      \n\n\n"

      Account.new(
        insales_subdomain: shop,
        password:          password_by_token(token),
        insales_id:        insales_id,
        delivery_id:       delivery_id,
        store_city_id:     store_city_id,
        pricing_policy:    pricing_policy
      ).save
      #@delivery_id = 0
    end



    # def cache_delivery_id shop, delivery_id
    #   account = Account.find_by(insales_subdomain: self.prepare_domain(shop))
    #   account.delivery_id = delivery_id
    #   account.save
    # end

    # def get_delivery_id shop
    #   Account.find_by(insales_subdomain: self.prepare_domain(shop)).delivery_id
    # end

    def uninstall shop, password
      account = Account.find_by(insales_subdomain: self.prepare_domain(shop))
      return true unless account
      return false if account.password != password

      account.destroy
      true
    end

    # def info

    # end

    def install_delivery_variant
      #MyApp.configure_api(current_app.domain, current_app.password)
      #self.current_app.configure_api
      #InsalesApi::DeliveryVariant.all
      #InsalesApi::Account.find
      #delivery =

      InsalesApi::DeliveryVariant.new(
       :title => 'Курьер Exline Standard',
       :description => "ExLine - линия надежной доставки!",
       :type => "DeliveryVariant::External",
       :url => "http://rails.echelonsystems.ru/deliveries/standard/id/454613.json",
       :javascript => "",
       :customer_pickup => false,
       :add_payment_gateways => true #,
       # :delivery_locations => [
       #  {
       #    "city": null,
       #    "country": "KZ",
       #    "region": null
       #  }
      ).save
      #delivery.save
      #MyApp.cache_delivery_id params[:shop], delivery.id
    end


    # def get_deliveries
    #   InsalesApi::DeliveryVariant.all
    # end
  end
end
