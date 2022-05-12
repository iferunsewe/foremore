module SMS
  class Base
    def initialize; end

    def enqueue!
      Sms::Sender.new(phone_number, message).send!
    #   Delayed::Job.enqueue(job, priority: 20) if enqueue?
    end

    # def job
    #   SendSMSJob.new(phone_number, message)
    # end

    private

    def sms_opt_in?
      user.account.sms_opt_in
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
