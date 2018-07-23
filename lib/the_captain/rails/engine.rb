# frozen_string_literal: true

require "rails/engine"

module TheCaptain
  module Events
    class Engine < ::Rails::Engine
      isolate_namespace TheCaptain::Events

      initializer "the-captain-rails.initialize" do
        require "the_captain/rails"
      end
    end
  end
end
