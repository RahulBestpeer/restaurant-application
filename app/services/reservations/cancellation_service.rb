module Reservations
  class CancellationService
    CANCELLATION_FEE_PERCENTAGE = 3.0

    Result = Struct.new(
      :success?,
      :reservation,
      :refund_amount,
      :cancellation_fee,
      :payment,
      :errors,
      keyword_init: true
    )

    def self.call(reservation, cancelled_by: :customer)
      new(reservation, cancelled_by).call
    end

    def initialize(reservation, cancelled_by)
      @reservation = reservation
      @cancelled_by = cancelled_by.to_sym
    end

    def call
      return failure("Reservation is already cancelled") if cancelled?

      payment = completed_payment
      refund_amount = 0.to_d
      cancellation_fee = 0.to_d

      if payment
        cancellation_fee = calculate_cancellation_fee(payment)
        refund_amount = calculate_refund_amount(payment)
      end

      ActiveRecord::Base.transaction do
        payment.refund!(refund_amount) if payment && refund_amount > 0
        cancel_reservation!
      end

      Result.new(
        success?: true,
        reservation: @reservation,
        refund_amount: refund_amount,
        cancellation_fee: cancellation_fee,
        payment: payment,
        errors: []
      )
    rescue StandardError => e
      Rails.logger.error(
        "Reservation cancellation failed: " \
        "#{e.class}: #{e.message}"
      )

      failure(e.message)
    end

    private

    def cancelled?
      @reservation.status == "cancelled"
    end

    def completed_payment
      @reservation.payments
        .where(status: "completed")
        .order(created_at: :desc)
        .first
    end

    def calculate_cancellation_fee(payment)
      return 0.to_d if @cancelled_by == :restaurant

      total_amount =
        @reservation.total_amount.presence || payment.amount

      (
        total_amount.to_d *
        CANCELLATION_FEE_PERCENTAGE /
        100
      ).round(2)
    end

    def calculate_refund_amount(payment)
      return payment.amount if @cancelled_by == :restaurant

      cancellation_fee = calculate_cancellation_fee(payment)
      refund_amount = payment.amount.to_d - cancellation_fee

      [refund_amount, 0.to_d].max
    end

    def cancel_reservation!
      @reservation.update!(status: "cancelled")
    end

    def failure(message)
      Result.new(
        success?: false,
        reservation: @reservation,
        refund_amount: nil,
        cancellation_fee: nil,
        payment: nil,
        errors: [message]
      )
    end
  end
end
