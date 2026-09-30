module PaymentProviders
  class StripeProvider < Base
    def initialize
      Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")
    end

    def create_payment(payment_transaction)
      payment_intent = Stripe::PaymentIntent.create(
        amount: amount_in_paise(payment_transaction.amount),
        currency: payment_transaction.currency.downcase,
        metadata: {
          payment_id: payment_transaction.payment_id,
          payment_transaction_id: payment_transaction.id
        }
      )

      {
        provider_transaction_id: payment_intent.id,
        client_secret: payment_intent.client_secret,
        status: payment_intent.status
      }
    end

    def refund(payment_transaction, amount:)
      refund = Stripe::Refund.create(
        payment_intent: payment_transaction.provider_transaction_id,
        amount: amount_in_paise(amount)
      )

      {
        provider_transaction_id: refund.id,
        status: refund.status
      }
    end

    def parse_webhook(payload:, headers:)
      signature = headers["Stripe-Signature"]

      Stripe::Webhook.construct_event(
        payload,
        signature,
        ENV.fetch("STRIPE_WEBHOOK_SECRET")
      )
    end

    def retrieve_payment(payment_transaction)
      payment_intent = Stripe::PaymentIntent.retrieve(
        payment_transaction.provider_transaction_id
      )

      client_secret =
        if %w[
          requires_payment_method
          requires_confirmation
          requires_action
        ].include?(payment_intent.status)
          payment_intent.client_secret
        end

      {
        provider_transaction_id: payment_intent.id,
        client_secret: client_secret,
        status: payment_intent.status
      }
    end

    private

    def amount_in_paise(amount)
      (amount.to_d * 100).round
    end
  end
end
