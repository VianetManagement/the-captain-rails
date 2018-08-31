# frozen_string_literal: true

Rails.application.routes.draw do
  mount TheCaptain::Events::Engine => "/captain_event"
end
