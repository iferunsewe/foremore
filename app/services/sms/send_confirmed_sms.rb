module Sms
  class SendConfirmedSms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery)
      @delivery = delivery
    end
    
    private

    def message
      I18n.t("sms.confirmed",
              reference: delivery.order_reference,
              address: delivery.pickup_address_to_s,
              edit_delivery_url:  RouteHelpers.edit_delivery_url(delivery))
    end

    def user
      @delivery.user
    end
  end
end
