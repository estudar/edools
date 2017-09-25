require "bundler/setup"
require "edools"
require 'support/helpers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.include Helpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
