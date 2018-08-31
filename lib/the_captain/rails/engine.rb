# frozen_string_literal: true

require "rails/engine"

module TheCaptain
  module Events
    class Engine < ::Rails::Engine
      isolate_namespace TheCaptain::Events
      config.autoload_paths << File.expand_path("app/controllers", __dir__)

      initializer "the_captain_rails.initialize" do
        require "the_captain/rails"
      end
    end
  end
end
