require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tax
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_paths << Rails.root.join("app", "facades")
    config.autoload_paths << Rails.root.join("app", "lib")

    # Rails (6.1.1) does not set Vary: correctly, so Accept: must be ignored
    config.action_dispatch.ignore_accept_header = true

    config.action_dispatch.cookies_same_site_protection = :strict

    # Different databases have different types and expression syntax
    require "active_record/database_configurations"
    db_adapter = ActiveRecord::DatabaseConfigurations
      .new(Rails.application.config.database_configuration)
      .configs_for(env_name: Rails.env)[0].adapter
    config.paths["db"] = File.join("db", "schema", db_adapter)
  end
end
