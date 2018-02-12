Rails.application.routes.draw do
  mount Freegeoip::Engine => "/json"
end
