require "rails_helper"

describe Freegeoip::LookupsController, type: :request do
  describe "GET /json/:hostname_or_ip" do
    context "OK" do
      before do
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

      ## Engine mounted as "/json" in dummy app
      it "returns json" do
        get "/json/151.101.1.195"

        json = JSON.parse response.body
        expect(json).to eq({
          "ip" => "151.101.1.195",
          "country_code" => "US",
          "country_name" => "United States",
          "region_code" => "CA",
          "region_name" => "California",
          "city" => "San Francisco",
          "zip_code" => "94107",
          "time_zone" => "America/Los_Angeles",
          "latitude" => 37.7697,
          "longitude" => -122.3933,
          "metro_code" => 807,
        })
      end
    end

    context "Not Found" do
      it "renders 404 not found" do
        get "/json"

        expect(response.status).to eq(404)
        expect(response.body).to eq("404 page not found")
      end

      it "renders 404 not found" do
        get "/json/foobar"

        expect(response.status).to eq(404)
        expect(response.body).to eq("404 page not found")
      end
    end
  end
end
