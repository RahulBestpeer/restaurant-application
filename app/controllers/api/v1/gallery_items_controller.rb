module Api
  module V1
    class GalleryItemsController < ApplicationController
      def index
        items = GalleryItem.ordered

        items = items.by_category(params[:category]) if params[:category].present?
        items = items.by_type(params[:media_type])   if params[:media_type].present?
        items = items.featured                        if params[:featured] == "true"

        render json: items.map { |item| GalleryItemSerializer.render(item) }
      end

      def show
        item = GalleryItem.find(params[:id])
        render json: GalleryItemSerializer.render(item)
      end
    end
  end
end
