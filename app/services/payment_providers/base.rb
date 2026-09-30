module PaymentProviders
  class Base
    def create_payment(payment_transaction)
      raise NotImplementedError
    end

    def retrieve_payment(payment_transaction)
      raise NotImplementedError
    end

    def refund(payment_transaction, amount:)
      raise NotImplementedError
    end

    def parse_webhook(payload:, headers:)
      raise NotImplementedError
    end
  end
end
