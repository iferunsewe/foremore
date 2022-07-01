module Sms
  class Base
    def initialize; end

    def enqueue!
      Sms::Sender.new(phone_number, message).send! if Rails.env.production? && sms_opt_in?
    end

    private

    def sms_opt_in?
      user.sms_opt_in
    end

    def phone_number
      user.phone_number
    end

    def first_name
      user.first_name
    end

    def enqueue?
      sms_opt_in?
    end

    def user
      raise("Please define user in Subclass")
    end

    def message
      raise("Please define message in Subclass")
    end
  end
end
