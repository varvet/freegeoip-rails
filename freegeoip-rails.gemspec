$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "freegeoip/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "freegeoip-rails"
  s.version     = Freegeoip::VERSION
  s.authors     = ["Ingemar"]
  s.email       = ["ingemar@xox.se"]
  s.homepage    = "https://varvet.com"
  s.summary     = "Rails engine with IP geolocation API like Freegeoip"
  s.description = "Rails engine that provides an IP geolocation API that ducks with Freegeoip"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2"
  s.add_dependency "maxminddb"

  s.add_development_dependency "rspec-rails", "~> 3.7.2"
  s.add_development_dependency "pry"
end
