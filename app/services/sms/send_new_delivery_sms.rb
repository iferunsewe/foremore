module Sms
  class SendNewDeliverySms < Base
    attr_accessor :delivery
    RouteHelpers = Rails.application.routes.url_helpers

    def initialize(delivery, user)
      @delivery = delivery
      @user = user
    end

    private

    def message
      I18n.t("sms.new-delivery.message",
             first_name: first_name,
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
