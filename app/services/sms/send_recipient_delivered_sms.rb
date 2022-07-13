module Sms
  class SendRecipientDeliveredSms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery)
      @delivery = delivery
    end
    
    private

    def message
      I18n.t("sms.recipient-delivered",
              company_name: delivery.company_name,
              reference: delivery.order_reference,
              recipient_name: delivery.recipient_name)
    end

    def phone_number
      delivery.recipient_phone
    end

    def sms_opt_in?
      delivery.recipient_phone.present?
    end
  end
end
