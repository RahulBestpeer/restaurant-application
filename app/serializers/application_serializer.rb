class ApplicationSerializer
  def self.attachment_url(attachment)
    return nil unless attachment.attached?

    host = Rails.application.config.action_mailer.default_url_options[:host]
    port = Rails.application.config.action_mailer.default_url_options[:port]

    Rails.application.routes.url_helpers.rails_blob_url(
      attachment,
      host: host,
      port: port
    )
  rescue StandardError => e
    Rails.logger.error("Active Storage URL error: #{e.message}")
    nil
  end
end
