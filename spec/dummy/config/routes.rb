Rails.application.routes.draw do

  mount Docker::Engine => "/docker"
end
