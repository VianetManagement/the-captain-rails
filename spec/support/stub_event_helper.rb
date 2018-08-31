# frozen_string_literal: true

module StubEventHelper
  def stub_event(event_name, parse = false)
    event_name = event_name.end_with?(".json") ? event_name : "#{event_name}.json"
    event_file = file_fixture(event_name).read
    parse ? Oj.load(event_file, symbol_keys: true) : event_file
  end
  alias event_response stub_event
end

RSpec.configure do |config|
  config.include(StubEventHelper)
end
