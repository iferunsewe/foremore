module Sms
  class SendReadyToPickupSms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery, user)
      @delivery = delivery
      @user = user
    end
    
    private

    def message
      I18n.t("sms.ready-to-pickup",
              reference: delivery.id,
              address: delivery.pickup_address_to_s,
              delivery_url:  delivery_url)
    end

    def user
      @user
    end

    def delivery_url
      RouteHelpers.delivery_url(delivery)
    end
  end
end
