# frozen_string_literal: true

module Freegeoip
  class LookupsController < ApplicationController
    def index
      not_found
    end

    def show
      if result = Freegeoip::Lookup.hostname_or_ip(params[:hostname_or_ip])
        render json: result
      else
        not_found
      end
    end

    private

    def not_found
      render body: "404 page not found", status: 404
    end
  end
end
