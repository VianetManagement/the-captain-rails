# frozen_string_literal: true

module TheCaptain
  module Events
    class << self
      attr_accessor :adapter, :backend, :namespace, :event_filter, :event_key_filter

      def configure
        raise ArgumentError, "Must provide a block to configure events" unless block_given?
        yield self
      end

      def subscribe(kit_name, callable = Proc.new)
        backend.subscribe(namespace.to_regexp(kit_name), adapter.call(callable))
      end

      def all(callable = Proc.new)
        subscribe(nil, callable)
      end

      def instrument(event)
        event = event_filter.call(event)
        return unless event
        event_key = event_key_filter.call(event)
        backend.instrument(namespace.call(event_key), event)
      end

      def listening?(kit_name)
        namespaced_name = namespace.call(kit_name)
        backend.notifier.listening?(namespaced_name)
      end
    end

    Namespace = Struct.new(:value, :delimiter) do
      def call(name = nil)
        "#{value}#{delimiter}#{name&.to_s&.tr(' ', delimiter)&.downcase}"
      end

      def to_regexp(name = nil)
        /^#{Regexp.escape(call(name))}/
      end
    end

    NotificationAdapter = Struct.new(:subscriber) do
      def self.call(callable)
        new(callable)
      end

      def call(*args)
        payload = args.last
        subscriber.call(payload)
      end
    end

    self.adapter          = NotificationAdapter
    self.backend          = ActiveSupport::Notifications
    self.namespace        = Namespace.new("captain_event", ".")
    self.event_filter     = lambda { |event| event }
    self.event_key_filter = lambda { |event| event.dig(:decision, :kit) }
  end
end
