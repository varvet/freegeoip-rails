# frozen_string_literal: true

module Freegeoip
  module Config
    extend self

    attr_accessor :db_location, :param_name

    def configure
      yield self
    end
  end
end
