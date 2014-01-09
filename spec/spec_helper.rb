require "spec_helper"

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'rails/all'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "generator_spec"

Rails.backtrace_cleaner.remove_silencers!

# Load generators
Dir["./lib/generators/**/*.rb"].each { |f| require f }

# Load support files
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }