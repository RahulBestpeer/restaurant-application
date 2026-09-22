module Api
  module V1
    class MenuCategoriesController < ApplicationController
      INDEX_INCLUDES = { subcategories: [] }.freeze
      SHOW_INCLUDES  = { subcategories: { menu_items: [ :menu_category, { image_attachment: :blob } ] },
                         menu_items:    [ :menu_category, { image_attachment: :blob } ] }.freeze

      def index
        categories = MenuCategory.active.ordered.includes(INDEX_INCLUDES)
        categories = categories.by_type(params[:type]) if params[:type].present?
        categories = categories.root                   if params[:root] == "true"

        render json: categories.map { |c| MenuCategorySerializer.render(c, include_items: false) }
      end

      def show
        category = MenuCategory.active.includes(SHOW_INCLUDES).find_by!(slug: params[:id])
        render json: MenuCategorySerializer.render(category, include_items: true)
      end

      def menu_items
        category = MenuCategory.active.find_by!(slug: params[:menu_category_id])
        items = category.all_menu_items
                        .available
                        .ordered
                        .includes(:menu_category, image_attachment: :blob)
        items = items.featured if params[:featured].present?

        render json: items.map { |item| MenuItemSerializer.render(item) }
      end
    end
  end
end
