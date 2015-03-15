Rails.application.routes.draw do

  get 'site/index'

  mount Docker::Engine => "/docker"
end
