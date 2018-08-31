# frozen_string_literal: true

require_relative "boot"

# Pick the frameworks you want:
require "action_controller/railtie"

# require "active_job/railtie"
# require "active_model/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "the_captain/rails"

module Dummy
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.active_support.escape_html_entities_in_json = true
  end
end
