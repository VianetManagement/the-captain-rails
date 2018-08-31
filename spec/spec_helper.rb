# frozen_string_literal: true

require "bundler/setup"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require File.expand_path(f) }
Dir["#{File.dirname(__FILE__)}/**/*examples.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Clear out conflicting notifiers after each test.
  config.before do
    @event_filter     = TheCaptain::Events.event_filter
    @event_key_filter = TheCaptain::Events.event_key_filter
    @notifier         = TheCaptain::Events.backend.notifier
    TheCaptain::Events.backend.notifier = @notifier.class.new
  end

  config.after do
    TheCaptain::Events.event_filter     = @event_filter
    TheCaptain::Events.event_key_filter = @event_key_filter
    TheCaptain::Events.backend.notifier = @notifier
  end
end
