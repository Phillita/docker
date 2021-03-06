require 'coffee_script'
require 'jquery-rails'

module Docker
  class Engine < ::Rails::Engine
    isolate_namespace Docker

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end
end
