module Sms
  class SendDeliveringSms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery)
      @delivery = delivery
    end

    private

    def message
      I18n.t("sms.delivering",
             company_name: delivery.company_name,
             reference: delivery.order_reference,
             phone_number: delivery.rider.phone_number,
             recipient_name: delivery.recipient_name)
    end

    def phone_number
      delivery.recipient_phone
    end

    def first_name
      delivery.recipient_name.split(" ").first
    end

    def sms_opt_in?
      delivery.recipient_phone.present?
    end
  end
end
