# frozen_string_literal: true

require "rails_helper"

RSpec.describe TheCaptain::Events do
  describe ".configure" do
    it "Raises an error when a block isn't provided" do
      expect { described_class.configure }.to raise_error ArgumentError
    end

    it "Returns itself as the configurable object" do
      result = nil
      described_class.configure { |event| result = event }
      expect(result).to be(described_class)
    end

    context "when used for subscribing to events" do
      before do
        described_class.configure do |event|
          event.subscribe("user:flagged") { |_event| }
          event.subscribe("user:suspended") { |_event| }
        end
      end

      it { is_expected.to be_listening("user:flagged") }
      it { is_expected.to be_listening("user:suspended") }
      it { is_expected.not_to be_listening("user:banned") }
    end
  end

  describe ".subscribe" do
    let(:account_abuse_event) { stub_event("account_abuse/new_user", true) }
    let(:account_abuse_klass) do
      Class.new do
        def call(_event); end
      end
    end

    it "Can accept a Proc as its yield'er" do
      count = 0
      described_class.subscribe("user:flagged", proc { |_| count = 22 })
      expect { described_class.instrument(account_abuse_event) }.to change { count }.from(0).to(22)
    end

    it "Can accept a class instance that contains a call method" do
      klass_instance = account_abuse_klass.new
      allow(klass_instance).to receive(:call).with(account_abuse_event)

      described_class.subscribe("user:flagged", klass_instance)
      described_class.instrument(account_abuse_event)

      expect(klass_instance).to have_received(:call).with(account_abuse_event)
    end
  end

  describe ".listening?" do
    before { described_class.subscribe("user:flagged") { |_| } }

    it "Returns a truthy value when a valid subscription is set" do
      expect(described_class).to be_listening("user:flagged")
    end

    it "Does not listen to all by default" do
      expect(described_class).not_to be_listening(nil)
    end

    it "Does listen to all if defined" do
      described_class.all { |_| }
      expect(described_class).to be_listening(nil)
    end
  end
end
