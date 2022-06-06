module Sms
  class Sender
    class Error < StandardError; end

    attr_accessor :to_number, :message

    def initialize(to_number, message)
      @to_number = to_number
      @message = message
    end

    def send!
      if mobile_number?
        send_message
      else
        Rails.logger.error(
          "Sms::Sender::Error - Class: StandardError, Error Message: Not a mobile number"
        )
      end
    end

    def send_message
      client.messages.create(
        from: "foremore",
        to:   parsed_to_number.full_e164,
        body: message
      )
    rescue Twilio::REST::RestError => error
      Rails.logger.error(
        "Sms::Sender::Error - Class: Twilio::REST::RestError, " \
        "Error code: #{error.code}, " \
        "Error message: #{error.message}"
      )
    end

    private

    def mobile_number?
      parsed_to_number.type == :mobile
    end

    def parsed_to_number
      Phonelib.parse(to_number)
    end

    def client
      Twilio::REST::Client.new
    end

    def twilio_number
      ENV["TWILIO_NUMBER"]
    end
  end
end
