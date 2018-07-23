# frozen_string_literal: true

module TheCaptain
  module Events
    class << self
      attr_accessor :adapter, :backend, :namespace, :event_filter

      def subscribe_events
        yield self
      end

      def subscribe(name, callable = Proc.new)
        backend.subscribe(namespace.to_regex(name), adapter.call(callable))
      end

      def all(callable = Proc.new)
        subscribe nil, callable
      end

      def listening?(name)
        namespaced_name = namespace.call(name)
        backend.notifier.listening?(namespaced_name)
      end
    end

    Namespace = Struct.new(:value, :delimiter) do
      def call(name = nil)
        "#{value}#{delimiter}#{name}"
      end

      def to_regexp(name = nil)
        /^#{Regexp.escape call(name)}/
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

    self.adapter      = NotificationAdapter
    self.backend      = ActiveSupport::Notifications
    self.namespace    = Namespace.new("captain_event", ".")
    self.event_filter = lambda { |event| event }
  end
end
