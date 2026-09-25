class GalleryItemSerializer < ApplicationSerializer
  def self.render(item)
    {
      id:          item.id,
      title:       item.title,
      description: item.description,
      alt_text:    item.alt_text,
      media_type:  item.media_type,
      category:    item.category,
      video_url:   item.video_url,
      featured:    item.featured,
      position:    item.position,
      image_url:   attachment_url(item.image)
    }
  end
end
