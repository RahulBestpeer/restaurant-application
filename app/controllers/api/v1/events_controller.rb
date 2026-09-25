module Api
  module V1
    class EventsController < ApplicationController
      def index
        events = Event.upcoming.ordered
        render json: events.map { |e| EventSerializer.render(e) }
      end

      def show
        event = Event.find(params[:id])
        render json: EventSerializer.render(event, detailed: true)
      end
    end
  end
end
