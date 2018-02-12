# frozen_string_literal: true

require "resolv"
require "maxminddb"
require "open-uri"

module Freegeoip
  class Lookup
    def self.hostname_or_ip(string, locale = "en")
      ip = resolve string.to_s

      return nil unless ip

      result = lookup(ip)

      return nil if result.empty?

      {
        ip: ip,
        country_code: result.dig("country", "iso_code"),
        country_name: result.dig("country", "names", locale),
        region_code: result.dig("subdivisions", 0, "iso_code"),
        region_name: result.dig("subdivisions", 0, "names", locale),
        city: result.dig("city", "names", locale),
        zip_code: result.dig("postal", "code"),
        time_zone: result.dig("location", "time_zone"),
        latitude: result.dig("location", "latitude"),
        longitude: result.dig("location", "longitude"),
        metro_code: (result.dig("location", "metro_code") || 0),
      }
    end

    private
    def self.resolve(string)
      return string if string =~ Resolv::IPv4::Regex
      Resolv.getaddress string
    rescue Resolv::ResolvError
      nil
    end

    def self.lookup(ip)
      db.lookup(ip).to_hash
    end

    def self.db
      return @db if instance_variable_defined?("@db")
      @db = MaxMindDB.new read_db
    end


    def self.read_db
      if Freegeoip.config.db_location
        open Freegeoip.config.db_location
      else
        raise Freegeoip::ConfigError, "GeoLite2-City database location not configured"
      end
    end
  end
end
