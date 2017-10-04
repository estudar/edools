# frozen_string_literal: true

module Edools
  class Session
    attr_reader :id, :email, :credentials

    def initialize(data = {})
      @id = data[:id]
      @email = data[:email]
      @credentials = data[:credentials]
    end

    def self.create(user = {}, realm = {})
      new Edools::ApiRequest.unauthenticated_request(:post, base_url, user: user, realm: realm)
    end

    def self.base_url
      "#{Edools.base_url}/users/sign_in"
    end

    def set_as_global_environment
      return false if credentials.nil?

      Edools.api_token = credentials
      true
    end
  end
end
