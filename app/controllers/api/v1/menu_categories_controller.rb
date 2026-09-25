module Api
  module V1
    class MenuCategoriesController < ApplicationController
      INDEX_INCLUDES = { subcategories: [] }.freeze
      SHOW_INCLUDES  = { subcategories: { menu_items: [ :menu_category, { image_attachment: :blob } ] },
                         menu_items:    [ :menu_category, { image_attachment: :blob } ] }.freeze

      def index
        categories = MenuCategory.active.ordered.includes(INDEX_INCLUDES)
        categories = categories.by_type(params[:type]) if params[:type].present?

        render json: categories.map { |c| MenuCategorySerializer.render(c, include_items: false) }
      end

      def show
        category = MenuCategory.active
          .includes(SHOW_INCLUDES)
          .find_by!(slug: params[:slug])

        render json: MenuCategorySerializer.render(category, include_items: true)
      end
    end
  end
end
