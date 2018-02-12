# frozen_string_literal: true

require "freegeoip/engine"

module Freegeoip
  autoload :Config, 'freegeoip/config'

  class ConfigError < StandardError; end

  def self.configure(&block)
    Config.configure(&block)
  end

  def self.config
    Config
  end
end
