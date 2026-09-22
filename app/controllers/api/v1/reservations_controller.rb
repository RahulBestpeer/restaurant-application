module Api
  module V1
    class ReservationsController < ApplicationController
      def show
        reservation = Reservation.find_by!(confirmation_code: params[:confirmation_code].upcase)
        render json: ReservationSerializer.render(reservation)
      end

      def create
        reservation = Reservation.new(reservation_params)

        if reservation.save
          render json: ReservationSerializer.render(reservation), status: :created
        else
          render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      private

      def reservation_params
        params.require(:reservation).permit(
          :name,
          :email,
          :phone,
          :party_size,
          :reservation_date,
          :reservation_time,
          :special_requests
        )
      end
    end
  end
end
