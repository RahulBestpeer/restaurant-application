module Api
  module V1
    class BusinessHoursController < ApplicationController
      def index
        render json: {
          weekly:   BusinessHour.weekly.map { |bh| BusinessHourSerializer.render(bh) },
          specials: BusinessHour.upcoming_overrides.map { |bh| BusinessHourSerializer.render(bh) }
        }
      end

      def availability
        date   = params.require(:date)
        parsed = Date.parse(date)
        info   = BusinessHour.effective_for(parsed)

        render json: build_response(parsed, info)
      rescue Date::Error
        render json: { error: "Invalid date format. Use YYYY-MM-DD." }, status: :bad_request
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def build_response(date, info)
        response = {
          date:     date.iso8601,
          day_name: BusinessHour::DAY_NAMES[date.wday],
          open:     info[:open],
          override: info[:override]
        }
        if info[:open]
          response[:open_time]  = info[:open_time]
          response[:close_time] = info[:close_time]
        end

        response[:reason]     = info[:reason]      if info[:reason].present?
        response
      end
    end
  end
end
