class ApplicationSerializer
  def self.attachment_url(attachment)
    return nil unless attachment.attached?

    url_options = Rails.application.config.action_controller.default_url_options

    options = {
      host: url_options[:host],
      protocol: url_options[:protocol]
    }

    options[:port] = url_options[:port] if url_options[:port].present?

    Rails.application.routes.url_helpers.rails_blob_url(
      attachment,
      **options
    )
  rescue StandardError => e
    Rails.logger.error("Active Storage URL error: #{e.message}")
    nil
  end
end
