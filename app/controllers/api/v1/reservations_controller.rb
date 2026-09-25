module Api
  module V1
    class ReservationsController < ApplicationController
      def show
        reservation = find_reservation

        render json: ReservationSerializer.render(reservation)
      end

      def create
        result = ::Reservations::CreatorService.new(
          create_params
        ).call

        if result.success?
          render(
            json: ReservationSerializer.render(result.reservation),
            status: :created
          )
        else
          render(
            json: {
              errors: result.errors
            },
            status: :unprocessable_entity
          )
        end
      rescue ActiveRecord::RecordNotUnique
        @create_attempts = (@create_attempts || 0) + 1

        if @create_attempts < 3
          retry
        end

        render(
          json: {
            error: "Could not create reservation. Please try again."
          },
          status: :unprocessable_entity
        )
      end

      def update
        reservation = find_reservation

        if reservation.status == "cancelled"
          return render(
            json: {
              error: "Cannot update a cancelled reservation"
            },
            status: :unprocessable_entity
          )
        end

        if reservation.paid?
          return render(
            json: {
              error: "Cannot modify a paid reservation"
            },
            status: :unprocessable_entity
          )
        end

        if reservation.update(update_params)
          render(
            json: ReservationSerializer.render(reservation)
          )
        else
          render(
            json: {
              errors: reservation.errors.full_messages
            },
            status: :unprocessable_entity
          )
        end
      end

      def cancel
        reservation = find_reservation

        result = ::Reservations::CancellationService.call(
          reservation,
          cancelled_by: :customer
        )

        if result.success?
          render(
            json: {
              reservation: ReservationSerializer.render(
                result.reservation
              ),
              cancellation_fee: result.cancellation_fee,
              refund_amount: result.refund_amount
            },
            status: :ok
          )
        else
          render(
            json: {
              errors: result.errors
            },
            status: :unprocessable_entity
          )
        end
      end

      private

      def find_reservation
        Reservation.find_by!(
          confirmation_code: params[:confirmation_code].upcase
        )
      end

      def create_params
        params.require(:reservation).permit(
          :name,
          :email,
          :phone,
          :party_size,
          :reservation_date,
          :reservation_time,
          :end_time,
          :special_requests,
          :table_id,
          :event_id,
          :notes
        )
      end

      def update_params
        params.require(:reservation).permit(
          :party_size,
          :reservation_date,
          :reservation_time,
          :end_time,
          :special_requests,
          :table_id,
          :notes
        )
      end
    end
  end
end
