# frozen_string_literal: true

TheCaptain::Events::Engine.routes.draw do
  root to: "webhook#event", via: :post
end
