module PaymentProviders
  class Registry
    def self.for(provider)
      case provider.to_s
      when "stripe"
        StripeProvider.new
      else
        raise ArgumentError, "Unsupported payment provider: #{provider}"
      end
    end
  end
end
