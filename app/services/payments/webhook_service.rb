module Payments
  class WebhookService
    def initialize(event:, provider:)
      @event = event
      @provider = provider
    end

    def call
      case @event.type
      when "payment_intent.succeeded"
        handle_payment_succeeded
      when "payment_intent.payment_failed"
        handle_payment_failed
      end
    end

    private

    def handle_payment_succeeded
      provider_transaction_id = @event.data.object.id

      transaction = PaymentTransaction.find_by(
        provider: @provider,
        provider_transaction_id: provider_transaction_id
      )

      return unless transaction

      ActiveRecord::Base.transaction do
        transaction.lock!

        unless transaction.completed?
          transaction.complete!

          payment = transaction.payment
          payment.complete!

          payment.reservation.update!(
            status: "confirmed"
          )
        end
      end
    end

    def handle_payment_failed
      provider_transaction_id = @event.data.object.id

      transaction = PaymentTransaction.find_by(
        provider: @provider,
        provider_transaction_id: provider_transaction_id
      )

      return unless transaction

      transaction.fail!

      transaction.payment.update!(
        status: "failed"
      )
    end
  end
end
