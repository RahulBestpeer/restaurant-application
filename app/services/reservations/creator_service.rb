module Reservations
  class CreatorService
    Result = Struct.new(
      :success?,
      :reservation,
      :errors,
      keyword_init: true
    )

    def initialize(params)
      @params = params
    end

    def call
      reservation = Reservation.new(@params)

      if reservation.event_id.present?
        save_event_reservation(reservation)
      else
        reservation.save
      end

      Result.new(
        success?: reservation.persisted?,
        reservation: reservation,
        errors: reservation.errors.full_messages
      )
    end

    private

    def save_event_reservation(reservation)
      ActiveRecord::Base.transaction do
        locked_event = Event.lock.find_by(id: reservation.event_id)

        unless locked_event
          reservation.errors.add(
            :event,
            "not found"
          )

          raise ActiveRecord::Rollback
        end

        if locked_event.spots_remaining < reservation.party_size
          reservation.errors.add(
            :event,
            "does not have enough spots for your party size"
          )

          raise ActiveRecord::Rollback
        end

        unless reservation.save
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
