module Sms
  class SendDeliveredSms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery)
      @delivery = delivery
    end
    
    private

    def message
      I18n.t("sms.delivered",
              reference: delivery.order_reference,
              recipient_name: delivery.recipient_name,
              new_delivery_url: RouteHelpers.new_delivery_url)
    end

    def user
      @delivery.user
    end
  end
end
