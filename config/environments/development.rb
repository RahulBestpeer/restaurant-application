require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  config.cache_store = :null_store
  config.active_storage.service = :local

  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_controller.default_url_options = {
    host: ENV.fetch("APP_HOST", "localhost"),
    protocol: "http"
  }

  config.active_storage.default_url_options = {
    host: ENV.fetch("APP_HOST", "localhost"),
    protocol: "http"
  }
end
