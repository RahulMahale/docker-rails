require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DockerRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use PDFKit::Middleware
    config.asset_host = Proc.new { |source, request|
      if request && request.env['Rack-Middleware-PDFKit']
        # Force wkhtmltopdf to load assets from localhost:80, which differs from request.host_with_port in Docker
        'http://localhost:80'
      end
    }

    config.time_zone = 'Berlin'
  end
end

require_relative 'version'
