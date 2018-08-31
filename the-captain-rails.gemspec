# frozen_string_literal: true

version = File.read(File.expand_path("VERSION", __dir__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "the_captain_rails"
  spec.version       = version
  spec.authors       = ["George J Protacio-Karaszi"]
  spec.email         = ["george@elevatorup.com"]

  spec.summary       = "Ruby on Rails bindings for the The Captain API"
  spec.description   = "The Captain will tell, talk, and taddle on those pesky fraudulent scalliwags."
  spec.homepage      = "https://github.com/VianetManagement/the-captain-rails"
  spec.license       = "MIT"

  spec.files         = Dir["{app,config,lib}/**/*.rb", "README.md"]
  spec.require_paths = ["lib", "app", "config"]

  spec.add_development_dependency "rails",       "~> 5.0"
  spec.add_development_dependency "rake",        "~> 11.3"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
end
