$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "docker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "docker"
  s.version     = Docker::VERSION
  s.authors     = ["Tayler Phillips"]
  s.email       = ["taylerphillips20@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Docker."
  s.description = "TODO: Description of Docker."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency 'coffee-script', '~> 2.3.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.3'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency "therubyracer"
  s.add_dependency "less-rails"
  s.add_dependency "twitter-bootstrap-rails"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails", "~> 2.12.2"
  s.add_development_dependency "factory_girl_rails", "~> 4.0"
end
