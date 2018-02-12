require "rails_helper"

describe Freegeoip::Lookup do
  describe ".hostname_or_ip" do
    context "when db path not configured" do
      before do
        if Freegeoip::Lookup.instance_variable_defined? "@db"
          Freegeoip::Lookup.remove_instance_variable "@db"
        end
        Freegeoip::Config.db_location = nil
      end

      after do
        Freegeoip::Config.db_location = "/foo/bar"
      end

      it "raises an error" do
        expect {
          Freegeoip::Lookup.hostname_or_ip("8.8.8.8")
        }.to raise_error(Freegeoip::ConfigError, /database location not configured/)
      end
    end

    context "when given an incorrect IP address" do
      it "returns nil" do
        expect(
          Freegeoip::Lookup.hostname_or_ip("123.123.123.256")
        ).to be_nil
      end
    end

    context "when given an incorrect hostname" do
      it "returns nil" do
        expect(
          Freegeoip::Lookup.hostname_or_ip("example")
        ).to be_nil
      end
    end

    context "when given an IP address" do
      before do
        # Some locales ommitted
        db_response = {
          "city" => {
            "geoname_id"=>2673730,
            "names" => {
              "de" => "Stockholm",
              "en" => "Stockholm",
            }
          },
          "continent" => {
            "code" => "EU",
            "geoname_id" => 6255148,
            "names" => {
              "de" => "Europa",
              "en" => "Europe",
            }
          },
          "country" => {
            "geoname_id" => 2661886,
            "iso_code" => "SE",
            "names" => {
              "de" => "Schweden",
              "en" => "Sweden",
            }
          },
          "location" => {
            "accuracy_radius" => 1,
            "latitude" => 59.35,
            "longitude" => 17.9167,
            "time_zone" => "Europe/Stockholm"
          },
          "postal" => {
            "code" => "168 53"
          },
          "registered_country" => {
            "geoname_id" => 2661886,
            "iso_code" => "SE",
            "names" => {
              "de" => "Schweden",
              "en" => "Sweden",
            }
          },
          "subdivisions" => [
            {
              "geoname_id" => 2673722,
              "iso_code" => "AB",
              "names" => {
                "de" => "Stockholm",
                "en" => "Stockholm",
              }
            }
          ]
        }
        allow(Freegeoip::Lookup).to receive(:lookup) { db_response }
      end

      it "returns a hash" do
        expect(
          Freegeoip::Lookup.hostname_or_ip("217.211.177.11")
        ).to eq({
          ip: "217.211.177.11",
          country_code: "SE",
          country_name: "Sweden",
          region_code: "AB",
          region_name: "Stockholm",
          city: "Stockholm",
          zip_code: "168 53",
          time_zone: "Europe/Stockholm",
          latitude: 59.35,
          longitude: 17.9167,
          metro_code: 0,
        })
      end
    end

    context "when given a hostname" do
      before do
        allow(Resolv).to receive(:getaddress) { "151.101.1.195" }

        db_response = {
          "city" => {
            "geoname_id" => 5391959,
            "names" => {
              "de" => "San Francisco",
              "en" => "San Francisco",
            }
          },
          "continent" => {
            "code" => "NA",
            "geoname_id" => 6255149,
            "names" => {
              "de" => "Nordamerika",
              "en" => "North America",
            }
          },
          "country" => {
            "geoname_id" => 6252001,
            "iso_code" => "US",
            "names" => {
              "de" => "USA",
              "en" => "United States",
            }
          },
          "location" => {
            "accuracy_radius" => 1000,
            "latitude" => 37.7697,
            "longitude" => -122.3933,
            "metro_code" => 807,
            "time_zone" => "America/Los_Angeles"
          },
          "postal" => {
            "code" => "94107"
          },
          "registered_country" => {
            "geoname_id" => 6252001,
            "iso_code" => "US",
            "names" => {
              "de" => "USA",
              "en" => "United States",
            }
          },
          "subdivisions" => [
            {
              "geoname_id" => 5332921,
              "iso_code" => "CA",
              "names" => {
                "de" => "Kalifornien",
                "en" => "California",
              }
            }
          ]
        }
        allow(Freegeoip::Lookup).to receive(:lookup) { db_response }
      end

      it "returns a hash" do

        expect(
          Freegeoip::Lookup.hostname_or_ip("www.varvet.com")
        ).to eq({
          ip: "151.101.1.195",
          country_code: "US",
          country_name: "United States",
          region_code: "CA",
          region_name: "California",
          city: "San Francisco",
          zip_code: "94107",
          time_zone: "America/Los_Angeles",
          latitude: 37.7697,
          longitude: -122.3933,
          metro_code: 807,
        })
      end
    end
  end
end
