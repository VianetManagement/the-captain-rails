# frozen_string_literal: true

require "rails/railtie"

module TheCaptain
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "the-captain-rails.init" do
        require "the_captain/rails"
      end
    end
  end
end
