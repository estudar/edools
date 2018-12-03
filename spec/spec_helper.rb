# frozen_string_literal: true

require 'bundler/setup'
require 'edools'
require 'support/helpers'
require 'support/vcr'
require 'webmock/rspec'
require 'pry'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.include Helpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around(:each) do |example|
    preserving_environment do
      example.run
    end
  end
end
Edools.api_token = 'randomapikey'
