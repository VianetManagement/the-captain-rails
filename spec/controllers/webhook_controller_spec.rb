# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

module TheCaptain
  module Events
    RSpec.describe WebhookController, type: :controller do
      routes { TheCaptain::Events::Engine.routes }

      let(:account_abuse_event) { stub_event("account_abuse/new_user", true) }

      context "with a subscribed event" do
        before do
          @results, @all_results = nil
        end

        context "when a subscribed event is triggered" do
          before do
            TheCaptain::Events.subscribe("user:flagged") { |event| @results = event.uuid }
          end

          it "triggers the event that was subscribed to" do
            webhook(account_abuse_event)
            expect(@results).to eq(account_abuse_event[:uuid])
          end
        end

        context "when all is defined" do
          let(:content_abuse_event) { stub_event("content_abuse/message", true) }

          before do
            TheCaptain::Events.subscribe("Account Abuse") { |event| @results = event.uuid }
            TheCaptain::Events.all { |event| @all_results = event.uuid }
          end

          it "Triggers all and the listening event when defined" do
            webhook(account_abuse_event)
            expect(@all_results).to eq(account_abuse_event[:uuid])
          end

          it "Doesn't trigger events that don't matched the subscribed name" do
            webhook(content_abuse_event)
            expect(@results).to be_nil
          end
        end
      end

      context "without a subscribed event" do
        before do
          TheCaptain::Events.subscribe("Random Act") { |event| @results = event.uuid }
        end

        it "Doesn't trigger any event that hasn't been subscribed to" do
          webhook(account_abuse_event)
          expect(@results).to be_nil
        end
      end

      def webhook(params)
        # request.env["RAW_POST_DATA"] = params.as_json.to_s
        # request.set_header("RAW_POST_DATA", params.to_json) # works with Rails 3, 4, or 5
        post :event, body: Oj.dump(params, mode: :compat)
      end
    end
  end
end
