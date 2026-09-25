module Api
  module V1
    class TablesController < ApplicationController
      def index
        tables = Table.active.ordered

        render json: tables.map { |table| TableSerializer.render(table) }
      end

      def available
        date       = params.require(:date)
        start_time = params.require(:start_time)
        end_time   = params.require(:end_time)
        party_size = params.require(:party_size).to_i

        if party_size <= 0
          return render(
            json: { error: "party_size must be a positive integer" },
            status: :bad_request
          )
        end

        start_minutes = Table.time_to_minutes(start_time)
        end_minutes   = Table.time_to_minutes(end_time)

        if end_minutes <= start_minutes
          return render(
            json: { error: "end_time must be after start_time" },
            status: :bad_request
          )
        end

        duration_minutes = end_minutes - start_minutes

        tables = Table.active
          .where("capacity >= ?", party_size)
          .ordered

        render json: {
          date: date,
          start_time: start_time,
          end_time: end_time,
          duration_minutes: duration_minutes,
          duration_hours: (duration_minutes / 60.0).round(2),
          party_size: party_size,
          available_tables: tables.map do |table|
            TableSerializer.render(table).merge(
              booking_price: table.booking_price(start_time, end_time)
            )
          end
        }
      end
    end
  end
end
