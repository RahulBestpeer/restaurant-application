module Api
  module V1
    class TeamMembersController < ApplicationController
      def index
        members = TeamMember.active.ordered
        members = members.featured if params[:featured] == "true"

        render json: members.map { |m| TeamMemberSerializer.render(m) }
      end

      def show
        member = TeamMember.active.find(params[:id])
        render json: TeamMemberSerializer.render(member)
      end
    end
  end
end
