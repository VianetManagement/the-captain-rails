# frozen_string_literal: true

require "rails_helper"
module TheCaptain
  module Events
    RSpec.describe WebhookController, type: :controller do
      routes { TheCaptain::Events::Engine.routes }

      it "accepts requests" do
        pp webhook(ip_address: "192.168.1.1")
      end

      def webhook(params)
        request.env["RAW_POST_DATA"] = params.to_json # works with Rails 3, 4, or 5
        post :event
      end
    end
  end
end
