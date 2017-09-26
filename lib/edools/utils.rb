# frozen_string_literal: true

module Edools
  class Utils
    def self.api_token_from_env
      Edools.api_token = ENV['API_TOKEN']
    end
  end
end