class MenuCategorySerializer < ApplicationSerializer
  def self.render(category, include_items: false)
    data = {
      id:            category.id,
      slug:          category.slug,
      category_type: category.category_type,
      display_order: category.display_order,
      parent_id:     category.parent_id,
      name:          category.name
    }

    data[:subcategories] = category.subcategories
      .select(&:active?)
      .sort_by { |c| [ c.display_order || 0, c.name ] }
      .map { |sub| render(sub, include_items: include_items) }

    data[:menu_items] = category.menu_items
      .select(&:available?)
      .sort_by { |i| [ i.display_order || 0, i.name ] }
      .map { |item| MenuItemSerializer.render(item) } if include_items

    data
  end
end
