class MenuItemSerializer < ApplicationSerializer
  def self.render(item)
    {
      id:            item.id,
      name:          item.name,
      description:   item.description,
      alt_text:      item.alt_text,
      price:         item.price,
      display_order: item.display_order,
      available:     item.available,
      featured:      item.featured,
      dietary_flags: item.dietary_flags,
      category_slug: item.menu_category.slug,
      image_url:     attachment_url(item.image)
    }
  end
end
