# frozen_string_literal: true

Freegeoip::Engine.routes.draw do
  get "/*hostname_or_ip", to: "lookups#show", format: false
  get "/", to: "lookups#index", format: false
end
