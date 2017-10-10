#gem_dir = Gem::Specification.find_by_name("insales_api").gem_dir
#require "#{gem_dir}/lib/insales_api/helpers/init_api"
class Account < ActiveRecord::Base
  #include InsalesApi
  #include InsalesApi #::Helpers
  validates_presence_of :insales_id
  #validates_presence_of :delivery_id
  validates_presence_of :insales_subdomain
  validates_presence_of :password
  #self.insales_domain = 'myshop-eo558.myinsales.ru'
  #self.insales_password = 'c4ea5bfae08e32c6779c2983702b07ad'

  # def find_deliveries
  #   MyApp.configure_api('myshop-eo558.myinsales.ru', 'c4ea5bfae08e32c6779c2983702b07ad')
  #   #account = InsalesApi::Account.find
  #   InsalesApi::DeliveryVariant.all
  #   #account.init_api # { InsalesApi::DeliveryVariant.all }
  #    #configure(MyApp.api_key, session["app"].domain, session["app"].password).all
  # end

  #init_api_for :find_deliveries
end
