class WebhooksController < ApplicationController
  def create
    provider_name = params[:provider]

    provider = PaymentProviders::Registry.for(provider_name)

    event = provider.parse_webhook(
      payload: request.body.read,
      headers: request.headers
    )

    Payments::WebhookService.new(
      event: event,
      provider: provider_name
    ).call

    head :ok
  rescue Stripe::SignatureVerificationError => e
    Rails.logger.error(
      "Stripe webhook signature verification failed: #{e.message}"
    )

    render(
      json: { error: "Invalid webhook signature" },
      status: :bad_request
    )
  rescue ArgumentError => e
    Rails.logger.error(
      "Webhook argument error: #{e.message}"
    )

    render(
      json: { error: e.message },
      status: :unprocessable_entity
    )
  rescue StandardError => e
    Rails.logger.error(
      "Webhook processing failed: #{e.class}: #{e.message}"
    )

    render(
      json: { error: "Webhook processing failed" },
      status: :unprocessable_entity
    )
  end
end
