# frozen_string_literal: true

Freegeoip::Engine.routes.draw do
  resources :lookups, only: :show, param: :hostname_or_ip, format: false
  get "/*hostname_or_ip", to: "lookups#show", format: false
end
