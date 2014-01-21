$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "restkit_generators/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "restkit_generators"
  s.version     = RestkitGenerators::VERSION
  s.authors     = ["Tom Spacek"]
  s.email       = ["ts@papercloud.com.au"]
  s.homepage    = "http://www.papercloud.com.au"
  s.summary     = "Generate RestKit mappings from ActiveModel Serializers"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "xcodeproj", "~> 0.10.0"
  
  s.add_development_dependency "active_model_serializers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "generator_spec"
end