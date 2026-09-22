module Api
  module V1
    class MenuItemsController < ApplicationController
      def index
        items = MenuItem.available.ordered.includes(:menu_category, image_attachment: :blob)
        items = items.joins(:menu_category).where(menu_categories: { slug: params[:category] }) if params[:category].present?
        items = items.featured if params[:featured].present?

        render json: items.map { |item| MenuItemSerializer.render(item) }
      end

      def show
        item = MenuItem.available.includes(:menu_category, image_attachment: :blob).find(params[:id])
        render json: MenuItemSerializer.render(item)
      end
    end
  end
end
