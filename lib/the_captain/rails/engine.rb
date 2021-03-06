# frozen_string_literal: true

require "rails/engine"

module TheCaptain
  module Events
    class Engine < ::Rails::Engine
      isolate_namespace TheCaptain::Events

      initializer "the_captain_rails.initialize" do
        require "the_captain_rails"
      end
    end
  end
end
