# frozen_string_literal: true

module TheCaptain
  module Events
    class WebhookController < ActionController::Base
      if ::Rails.application.config.action_controller.default_protect_from_forgery
        skip_before_action :verify_authenticity_token
      end

      # post
      def event
        ::TheCaptain::Events.instrument(process_event)
        head :ok
      end

      private

      def process_event
        request_body = request.body.read
        request_url  = request.original_url
        http_version = request.headers["version"] || "HTTP/1.1"
        response     = construct_response_from(request_body, request_url, http_version)
        ::TheCaptain::Response::CaptainVessel.new(response)
      end

      def construct_response_from(payload, uri_destination, http_version)
        HTTP::Response.new(body: payload, uri: uri_destination, status: 200, version: http_version)
      end
    end
  end
end
