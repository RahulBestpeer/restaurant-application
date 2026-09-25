class ApplicationSerializer
  def self.attachment_url(attachment)
    return nil unless attachment.attached?

    host = Rails.application.config.action_controller.default_url_options[:host]
    protocol = Rails.application.config.action_controller.default_url_options[:protocol]

    Rails.application.routes.url_helpers.rails_blob_url(
      attachment,
      host: host,
      protocol: protocol
    )
  rescue StandardError => e
    Rails.logger.error("Active Storage URL error: #{e.message}")
    nil
  end
end
