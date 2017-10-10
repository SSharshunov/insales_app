class MyDeliveries < InsalesApi::DeliveryVariant

  class << self

    #self.insales_domain = 'myshop-eo558.myinsales.ru'
    #self.insales_password = 'c4ea5bfae08e32c6779c2983702b07ad'

    def all
      InsalesApi::DeliveryVariant.all
    end

  end
end
