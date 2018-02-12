[![Build status](https://travis-ci.org/varvet/freegeoip-rails.svg?branch=master)](https://travis-ci.org/varvet/freegeoip-rails)

# Freegeoip

This gem provides a simple Rails engine with an IP geolocation API that ducks with [Freegeoip](https://github.com/fiorix/freegeoip).

It reads MaxMindDB's open source GeoLite2 City database, with the help of [maxminddb](https://github.com/yhirose/maxminddb) gem, a pure Ruby implementation.

You can find MaxMind's GeoLite2 City database [here](https://dev.maxmind.com/geoip/geoip2/geolite2/).


## Installation

Add this line to your application's Gemfile:

```ruby
gem "freegeoip-rails", require: "freegeoip"
```

Mount the engine in your routes file:

```ruby
  mount Freegeoip::Engine, at: "/json"
```

Add an initializer like `config/initializers/freegeoip.rb` and tell the engine where it can find your GeoLite2 City database:

```ruby
  Freegeoip.configure do |config|
    # Anything that can be opened by OpenURI
    config.db_location = Rails.root.join "vendor/maxminddb/GeoLite2-City.mmdb"
  end
```

Start your web server and point your browser to `http://localhost:3000/json/www.ruby-lang.org` or `http://localhost:3000/json/151.101.1.178` and you should get a response with JSON data.

## Contributing

Contributions are always welcome.


## Varvet

Crafted with love at [Varvet](https://www.varvet.com/).
Skapad med omsorg av [Varvet digital byrå](https://www.varvet.se/).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
